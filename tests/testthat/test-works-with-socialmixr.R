test_that("socialmixr::load_survey()/as_contact_survey()/clean() works", {
  skip_if_not_installed("socialmixr")
  vcr::local_cassette("socialmixr-integration")

  polymod_url <- "https://doi.org/10.5281/zenodo.3874557"
  peru_url <- "https://doi.org/10.5281/zenodo.1095664"

  polymod_survey <- download_survey(polymod_url, verbose = FALSE)
  peru_survey <- download_survey(peru_url, verbose = FALSE)

  polymod_loaded <- suppressWarnings(socialmixr::load_survey(polymod_survey))
  expect_no_error(socialmixr::clean(polymod_loaded))
  expect_no_error(suppressWarnings(socialmixr::load_survey(polymod_survey)))
  expect_no_error(suppressWarnings(socialmixr::as_contact_survey(
    polymod_loaded
  )))
  peru_loaded <- suppressWarnings(socialmixr::load_survey(peru_survey))
  expect_no_error(suppressWarnings(socialmixr::load_survey(peru_survey)))
  expect_no_error(suppressWarnings(socialmixr::as_contact_survey(peru_loaded)))
  expect_no_error(socialmixr::clean(peru_loaded))
})


test_that("socialmixr::contact_matrix() works", {
  skip_if_not_installed("socialmixr")
  vcr::local_cassette("socialmixr-integration")

  polymod_url <- "https://doi.org/10.5281/zenodo.3874557"
  peru_url <- "https://doi.org/10.5281/zenodo.1095664"

  polymod_loaded <- suppressWarnings(
    socialmixr::load_survey(download_survey(polymod_url, verbose = FALSE))
  )
  peru_loaded <- suppressWarnings(
    socialmixr::load_survey(download_survey(peru_url, verbose = FALSE))
  )

  expect_no_error(socialmixr::contact_matrix(polymod_loaded))
  expect_no_error(
    socialmixr::contact_matrix(
      polymod_loaded,
      countries = "United Kingdom",
      age.limits = c(0, 18, 65)
    )$matrix
  )
  expect_no_error(socialmixr::contact_matrix(peru_loaded))
  expect_no_error(
    socialmixr::contact_matrix(
      peru_loaded,
      countries = "Peru",
      age.limits = c(0, 18, 65)
    )$matrix
  )
})
