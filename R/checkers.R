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

check_record_is_downloadable <- function(
  records,
  survey_url,
  call = rlang::caller_env()
) {
  # get_zenodo() returns the exception rather than raising when the request
  # fails, which would otherwise look like a record with no files
  if (inherits(records, "ZenodoException")) {
    cli::cli_abort(
      message = c(
        "Zenodo returned an error for {survey_url}.",
        "x" = "{records$message}", # nolint
        "i" = "Status: {records$status}." # nolint
      ),
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
