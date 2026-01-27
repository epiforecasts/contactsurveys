test_that("list_surveys() caches to disk and returns non-empty result", {
  vcr::local_cassette("list-survey")
  dat <- list_surveys(verbose = FALSE)
  expect_s3_class(dat, c("data.table", "data.frame"))
  expect_gt(nrow(dat), 0)
  expect_true(all(c("title", "creator") %in% names(dat)))
  # verify file exists
  survey_path <- file.path(tempdir(), "survey_list.rds")
  expect_true(file.exists(survey_path))

  # verify time taken is shorter on a second run
  list_surveys(overwrite = TRUE, verbose = FALSE)
  mtime_before <- file.info(survey_path)$mtime
  . <- list_surveys(verbose = FALSE) # nolint
  mtime_after <- file.info(survey_path)$mtime
  expect_identical(mtime_after, mtime_before)
  # verify message when overwrite = FALSE
  expect_message(
    object = list_surveys(),
    regexp = "Files already exist at"
  )
})

test_that("list_surveys() works with a custom directory", {
  vcr::local_cassette("list-survey")
  tmp <- withr::local_tempdir()
  dat <- list_surveys(directory = tmp, verbose = FALSE)
  expect_s3_class(dat, c("data.table", "data.frame"))
  expect_true(file.exists(file.path(tmp, "survey_list.rds")))
})

test_that("list_surveys() is verbose or silent when verbose = TRUE or FALSE", {
  vcr::local_cassette("list-survey")
  expect_silent(
    dat_silent <- list_surveys(verbose = FALSE, overwrite = TRUE) # nolint
  )
  expect_s3_class(dat_silent, c("data.table", "data.frame"))
})
