check_survey_is_length_one <- function(survey, call = rlang::caller_env()) {
  if (
    !is.character(survey) ||
      length(survey) != 1L ||
      is.na(survey) ||
      !nzchar(survey)
  ) {
    cli::cli_abort(
      message = c(
        "{.arg survey} must be a character of length 1.",
        "i" = "We see survey is of length {.val {length(survey)}}:", # nolint
        "{survey}"
      ),
      call = call
    )
  }
}

check_is_url_doi <- function(
  x,
  call = rlang::caller_env(),
  arg = rlang::caller_arg(x)
) {
  is_url <- is_doi(x) || grepl("^https?://", x)
  not_url <- !isTRUE(is_url)
  if (not_url) {
    cli::cli_abort(
      message = c(
        "{.arg {arg}} must be a DOI or URL.",
        "We see: {.val {x}}"
      ),
      call = call
    )
  }
}

check_is_rate <- function(rate, call = rlang::caller_env()) {
  if (!purrr::is_rate(rate)) {
    cli::cli_abort(
      message = c(
        "{.arg rate} must be a rate object.",
        "We see: {.obj_type_friendly {rate}}",
        "i" = "See {.fun purrr::rate_backoff} for how to make one." # nolint
      ),
      call = call
    )
  }
}

check_is_zenodo_survey <- function(survey, call = rlang::caller_env()) {
  # the condition zen4R itself applies before it asks Zenodo anything, checked
  # here so a DOI that cannot be a Zenodo one is settled without a request
  if (!grepl("zenodo", survey, fixed = TRUE)) {
    cli::cli_abort(
      message = c(
        "{.arg survey} must be a Zenodo DOI or URL.",
        "We see: {.val {survey}}",
        "i" = "See {.fun list_surveys} for the surveys available." # nolint
      ),
      call = call
    )
  }
}

check_download_is_complete <- function(
  survey_dir,
  records,
  survey_url,
  call = rlang::caller_env()
) {
  # zen4R checks the integrity of every file it was asked for, and errors on
  # one that never arrived, so its failure is held back until the files on
  # disk have been counted: which files are missing is the more useful report
  missing_files <- missing_zenodo_files(survey_dir, records)
  if (length(missing_files) > 0) {
    cli::cli_abort(
      message = c(
        "Download from {survey_url} was incomplete.",
        "x" = "{cli::qty(missing_files)}Missing file{?s}: {.file {missing_files}}", # nolint
        "i" = "The record lists {length(records$files)} file{?s}." # nolint
      ),
      class = "contactsurveys_transient_error",
      call = call
    )
  }

  # a dropped connection can leave a file on disk under the right name with
  # the wrong content, which the check above cannot tell from a complete
  # download; catch that here, before the file is trusted and cached
  corrupt_files <- corrupt_zenodo_files(survey_dir, records)
  if (length(corrupt_files) > 0) {
    unlink(file.path(survey_dir, corrupt_files))
    cli::cli_abort(
      message = c(
        "Download from {survey_url} was corrupted.",
        "x" = "{cli::qty(corrupt_files)}File{?s} failed the checksum check: {.file {corrupt_files}}", # nolint
        "i" = "Deleted {cli::qty(corrupt_files)}{?it/them}, so the retry fetches {cli::qty(corrupt_files)}{?it/them} again." # nolint
      ),
      class = "contactsurveys_transient_error",
      call = call
    )
  }
}

check_record_is_downloadable <- function(
  records,
  survey_url,
  call = rlang::caller_env()
) {
  check_zenodo_request_succeeded(records, survey_url, call = call)
  # every completeness check in download_survey() is vacuous for a record with
  # no files, so one that lists none would be cached as a complete download
  if (length(records$files) == 0) {
    cli::cli_abort(
      message = c(
        "The record at {survey_url} lists no files.",
        "i" = "There is nothing to download; the record may still be under embargo, or the DOI may not point at a survey." # nolint
      ),
      call = call
    )
  }
}

# a server error or a rate limit is worth waiting out; a 400, 403 or 404 says
# the same thing however often it is asked
is_retryable_status <- function(status) {
  retryable <- c(408L, 425L, 429L, 500L, 502L, 503L, 504L)
  isTRUE(suppressWarnings(as.integer(status)) %in% retryable)
}

check_zenodo_request_succeeded <- function(
  response,
  survey_url,
  call = rlang::caller_env()
) {
  # zen4R returns the exception rather than raising when the request fails,
  # which would otherwise be mistaken for a record or a citation
  if (inherits(response, "ZenodoException")) {
    cli::cli_abort(
      message = c(
        "Zenodo returned an error for {survey_url}.",
        "x" = "{response$message}", # nolint
        "i" = "Status: {response$status}." # nolint
      ),
      class = if (is_retryable_status(response$status)) {
        "contactsurveys_transient_error"
      },
      call = call
    )
  }
}

is_citation_text <- function(reply_text, style) {
  nzchar(reply_text) &&
    !startsWith(reply_text, "{") &&
    (style != "bibtex" || startsWith(reply_text, "@"))
}

# Zenodo's error replies are JSON, e.g. {"message":"133 per 1 minute",
# "status":429}; anything else (an HTML gateway page, an empty reply) has no
# message or status to report
zenodo_error_reply <- function(reply_text) {
  reply <- NULL
  if (startsWith(reply_text, "{")) {
    reply <- tryCatch(jsonlite::fromJSON(reply_text), error = function(e) NULL)
  }
  error_message <- reply$message
  status <- reply$status
  list(
    message = if (is.character(error_message)) error_message[1],
    status = if (length(status) == 1L) status
  )
}

check_citation_is_returned <- function(
  citation,
  style,
  survey_url,
  call = rlang::caller_env()
) {
  # zen4R does not check the status of the request that fetches the citation:
  # it returns the body of the reply, so a rate limit or a gateway error comes
  # back as the text of the citation
  reply_text <- ""
  if (is.character(citation) && length(citation) == 1L && !is.na(citation)) {
    reply_text <- trimws(citation)
  }
  if (is_citation_text(reply_text, style)) {
    return(invisible(NULL))
  }

  reply <- zenodo_error_reply(reply_text)
  cli::cli_abort(
    message = c(
      "Zenodo did not return a citation for {survey_url}.",
      "x" = if (!is.null(reply$message)) "{reply$message}", # nolint
      "i" = if (!is.null(reply$status)) "Status: {reply$status}." # nolint
    ),
    class = if (is_retryable_status(reply$status)) {
      "contactsurveys_transient_error"
    },
    call = call
  )
}
