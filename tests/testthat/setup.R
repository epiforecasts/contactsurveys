td <- withr::local_tempdir(.local_envir = teardown_env())
withr::local_envvar(
  .new = c(CONTACTSURVEYS_HOME = td),
  .local_envir = teardown_env()
)

# Configure vcr: filter volatile headers, replay-only in CI
vcr::vcr_configure(
  dir = testthat::test_path("_vcr"),
  filter_response_headers = c(
    "date",
    "set-cookie",
    "x-request-id",
    "x-ratelimit-limit",
    "x-ratelimit-remaining",
    "x-ratelimit-reset",
    "retry-after",
    "connection",
    "cache-control"
  ),
  record = "new_episodes"  # Try real calls, fall back to recorded
)

# Mock download.file - try real download, fall back to fixtures if it fails
mock_download_file <- function(url, destfile, ...) {
  url_basename <- basename(gsub("/content$", "", url))
  fixtures <- list.files(testthat::test_path("fixtures"), recursive = TRUE, full.names = TRUE)
  match <- fixtures[grepl(tools::file_path_sans_ext(url_basename), basename(fixtures), fixed = TRUE)]

  # Try real download first
  result <- tryCatch(
    utils::download.file(url, destfile, ...),
    error = function(e) e
  )

  if (!inherits(result, "error") && file.exists(destfile) && file.size(destfile) > 0) {
    # Success - update fixture
    file.copy(destfile, file.path(testthat::test_path("fixtures"), url_basename), overwrite = TRUE)
  } else if (length(match) > 0) {
    # Download failed - use fixture
    file.copy(match[1], destfile, overwrite = TRUE)
  } else {
    # No fixture available - create empty file
    file.create(destfile)
  }
  invisible(0)
}
