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
