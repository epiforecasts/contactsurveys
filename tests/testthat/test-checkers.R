test_that("check_is_url_doi() works", {
  skip_if_offline("zenodo.org")
  skip_on_cran()
  expect_snapshot(
    error = TRUE,
    check_is_url_doi(x = "a/mystery") # nolint
  )
  doi_peru <- "10.5281/zenodo.1095664" # nolint
  expect_no_error(
    check_is_url_doi(x = doi_peru)
  )
})

test_that("check_directory() works", {
  expect_no_warning(check_directory(directory = tempdir()))
  expect_no_warning(check_directory(directory = contactsurveys_dir()))

  tmp <- withr::local_tempdir()
  expect_warning(
    check_directory(directory = tmp),
    "Directory"
  )
})

test_that("ensure_dir_exists() works", {
  expect_snapshot(
    error = TRUE,
    ensure_dir_exists(directory = 123)
  )
})
