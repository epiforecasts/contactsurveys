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
  record = if (identical(Sys.getenv("CI"), "true")) "none" else "new_episodes"
)
