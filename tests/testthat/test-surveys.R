test_that("surveys can be downloaded with download_survey()", {
  vcr::local_cassette("download-survey")
  doi_peru <- "10.5281/zenodo.1095664" # nolint
  peru_survey_files <- download_survey(doi_peru, verbose = FALSE)
  expect_true(all(file.exists(peru_survey_files)))
  # expect contains peru
  expect_true(all(grepl("Peru", basename(peru_survey_files), fixed = TRUE)))
  # surveys downloaded have the same filepath
  peru_2 <- download_survey(doi_peru, overwrite = FALSE, verbose = FALSE)
  expect_identical(basename(peru_2), basename(peru_survey_files))
})

test_that("survey downloads are faster on cache", {
  vcr::local_cassette("download-survey")
  doi_peru <- "10.5281/zenodo.1095664" # nolint
  # First download (uses vcr cassette)
  download_survey(doi_peru, overwrite = TRUE, verbose = FALSE)
  # Second access uses local file cache (no API call)
  ds_time2 <- system.time(download_survey(
    doi_peru,
    overwrite = FALSE,
    verbose = FALSE
  ))
  # Re-download forces new API call (still replayed from cassette)
  ds_time1 <- system.time(download_survey(
    doi_peru,
    overwrite = TRUE,
    verbose = FALSE
  ))
  # Cache hit should be faster than re-download

  expect_lt(ds_time2["elapsed"], ds_time1["elapsed"])
})

test_that("download_survey() is silent when verbose = FALSE", {
  vcr::local_cassette("download-survey")
  doi_peru <- "10.5281/zenodo.1095664" # nolint
  expect_silent(
    . <- download_survey(doi_peru, verbose = FALSE) # nolint
  )
})

test_that("multiple DOI's cannot be loaded", {
  # This error is thrown before any API call, but use vcr for consistency
  vcr::local_cassette("download-survey")
  # nolint start
  doi_peru <- "10.5281/zenodo.1095664"
  doi_zimbabwe <- "10.5281/zenodo.1127693"
  expect_error(
    download_survey(
      survey = c(
        doi_peru,
        doi_zimbabwe
      ),
      verbose = FALSE
    )
  )
  # nolint end
})
