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

check_record_is_downloadable <- function(
  records,
  survey_url,
  call = rlang::caller_env()
) {
  # get_zenodo() returns the exception rather than raising when the request
  # fails, which would otherwise look like a record with no files
  if (inherits(records, "ZenodoException")) {
    # a server error or a rate limit is worth waiting out; a 400, 403 or 404
    # says the same thing however often it is asked
    retryable <- c(408L, 425L, 429L, 500L, 502L, 503L, 504L)
    cli::cli_abort(
      message = c(
        "Zenodo returned an error for {survey_url}.",
        "x" = "{records$message}", # nolint
        "i" = "Status: {records$status}." # nolint
      ),
      class = if (isTRUE(records$status %in% retryable)) {
        "contactsurveys_transient_error"
      },
      call = call
    )
  }
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
