test_that("surveys can be downloaded with download_survey()", {
  skip_if_offline("zenodo.org")
  skip_on_cran()

  doi_peru <- "10.5281/zenodo.1095664" # nolint
  peru_survey_files <- suppressMessages(download_survey(doi_peru))
  expect_true(all(file.exists(peru_survey_files)))
  # expect contains peru
  expect_true(all(grepl("Peru", basename(peru_survey_files), fixed = TRUE)))
  expect_snapshot(basename(peru_survey_files))
  # expect message from downloading again
  expect_snapshot(
    . <- download_survey(doi_peru, overwrite = FALSE) # nolint
  )
  # surveys downloaded have the same filepath
  peru_2 <- suppressMessages(download_survey(doi_peru, overwrite = FALSE))
  expect_identical(basename(peru_2), basename(peru_survey_files))
})

test_that("survey downloads are faster on cache", {
  doi_peru <- "10.5281/zenodo.1095664" # nolint
  ds_time2 <- system.time(download_survey(
    doi_peru,
    overwrite = FALSE
  ))
  ds_time1 <- system.time(download_survey(
    doi_peru,
    overwrite = TRUE
  ))

  expect_lt(ds_time2["elapsed"], ds_time1["elapsed"])
})

test_that("download_survey() is silent when verbose = FALSE", {
  skip_if_offline("zenodo.org")
  skip_on_cran()
  skip_on_ci()
  doi_peru <- "10.5281/zenodo.1095664" # nolint
  expect_silent(
    . <- download_survey(doi_peru, verbose = FALSE) # nolint
  )
  expect_snapshot(
    . <- download_survey(doi_peru, verbose = FALSE) # nolint
  )
})

test_that("multiple DOI's cannot be loaded", {
  skip_if_offline("zenodo.org")
  skip_on_cran()
  # nolint start
  doi_peru <- "10.5281/zenodo.1095664"
  doi_zimbabwe <- "10.5281/zenodo.1127693"
  expect_error(
    suppressMessages(download_survey(
      survey = c(
        doi_peru,
        doi_zimbabwe
      )
    ))
  )
  # nolint end
})
