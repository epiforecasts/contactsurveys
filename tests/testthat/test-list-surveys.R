test_that("list_surveys() caches to disk and returns non-empty result", {
  skip_if_offline("zenodo.org")
  skip_on_cran()
  dat <- list_surveys()
  expect_s3_class(dat, c("data.table", "data.frame"))
  expect_gt(nrow(dat), 0)
  expect_true(all(c("title", "creator") %in% names(dat)))
  # verify file exists
  survey_path <- file.path(contactsurveys_dir(), "survey_list.rds")
  expect_true(file.exists(survey_path))

  # verify time taken is shorter on a second run
  list_surveys(overwrite = TRUE)
  mtime_before <- file.info(survey_path)$mtime
  . <- list_surveys() # nolint
  mtime_after <- file.info(survey_path)$mtime
  expect_identical(mtime_after, mtime_before)
  # verify message when overwrite = FALSE
  expect_message(
    object = list_surveys(),
    regexp = "Files already exist at"
  )
})

test_that("list_surveys() gives warnings when non-default directory used ", {
  skip_if_offline("zenodo.org")
  skip_on_cran()
  tmp <- withr::local_tempdir()
  expect_warning(
    list_surveys(directory = tmp, verbose = TRUE),
    "Directory",
    fixed = TRUE
  )
})

test_that("list_surveys() is verbose or silent when verbose = TRUE or FALSE", {
  skip_if_offline("zenodo.org")
  skip_on_cran()
  expect_silent(
    dat_silent <- list_surveys(verbose = FALSE) # nolint
  )
  expect_s3_class(dat_silent, c("data.table", "data.frame"))
  expect_snapshot(
    . <- list_surveys(verbose = FALSE) # nolint
  )
})
