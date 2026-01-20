td <- withr::local_tempdir(.local_envir = teardown_env())
withr::local_envvar(
  .new = c(CONTACTSURVEYS_HOME = td),
  .local_envir = teardown_env()
)

# Configure vcr with 30-day cassette expiry
vcr::vcr_configure(
  dir = testthat::test_path("_vcr"),
  re_record_interval = 60 * 60 * 24 * 30
)
