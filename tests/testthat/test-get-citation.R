test_that("get_citation() works", {
  vcr::local_cassette("get-citation")
  polymod_doi <- "https://doi.org/10.5281/zenodo.3874557"
  polymod_citation <- get_citation(polymod_doi, verbose = FALSE)
  expect_type(polymod_citation, "character")
  expect_s3_class(polymod_citation, "csbib")
  expect_gt(nchar(polymod_citation), 1)
  expect_match(polymod_citation, "Zenodo", fixed = TRUE)
  expect_match(
    polymod_citation,
    "https://doi.org/10.5281/zenodo.3874557",
    fixed = TRUE
  )
  # verbosity works
  expect_message(get_citation(polymod_doi), "Citation fetched")

  # check error message for when invalid style used
  expect_snapshot(
    error = TRUE,
    get_citation(polymod_doi, style = "mystery", verbose = FALSE)
  )
})
