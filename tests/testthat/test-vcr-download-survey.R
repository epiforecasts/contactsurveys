test_that("download_survey() works", {
  vcr::local_cassette("download-survey")
  doi_peru <- "10.5281/zenodo.1095664" # nolint
  peru_survey_files <- download_survey(doi_peru, verbose = FALSE)
  expect_gt(length(peru_survey_files), 0)
  expect_true(all(file.exists(peru_survey_files)))
  # expect contains peru
  expect_true(all(grepl("Peru", basename(peru_survey_files), fixed = TRUE)))
})
