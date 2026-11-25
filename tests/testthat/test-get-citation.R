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

# a stand-in for the record zen4R::get_zenodo() returns, whose getCitation()
# gives back the body of Zenodo's reply whatever its status
fake_citation_record <- function(reply) {
  list(getCitation = function(style) reply)
}

zenodo_exception <- function(status) {
  structure(
    list(message = "Too Many Requests", status = status),
    class = "ZenodoException"
  )
}

test_that("get_citation() errors when Zenodo returns an error for the record", {
  polymod_doi <- "https://doi.org/10.5281/zenodo.3874557"
  local_mocked_bindings(get_zenodo = function(...) zenodo_exception(429L))

  # a rate limit is worth retrying, so the error says so
  expect_error(
    get_citation(polymod_doi, verbose = FALSE),
    "Too Many Requests",
    class = "contactsurveys_transient_error"
  )

  # a missing record is not
  local_mocked_bindings(get_zenodo = function(...) zenodo_exception(404L))
  err <- expect_error(get_citation(polymod_doi, verbose = FALSE))
  expect_false(inherits(err, "contactsurveys_transient_error"))
})

test_that("get_citation() errors when the citation request is rate limited", {
  polymod_doi <- "https://doi.org/10.5281/zenodo.3874557"
  # what Zenodo replies on a rate limit; zen4R returns it as the citation
  rate_limited <- '{"message":"133 per 1 minute","status":429}'

  for (style in c("bibtex", "apa")) {
    local_mocked_bindings(
      get_zenodo = function(...) fake_citation_record(rate_limited)
    )
    expect_error(
      get_citation(polymod_doi, style = style, verbose = FALSE),
      "133 per 1 minute",
      class = "contactsurveys_transient_error"
    )
  }
})

test_that("get_citation() errors on a reply that is not a citation", {
  polymod_doi <- "https://doi.org/10.5281/zenodo.3874557"

  # an error that is not worth retrying
  local_mocked_bindings(
    get_zenodo = function(...) {
      fake_citation_record('{"message":"Not found","status":404}')
    }
  )
  err <- expect_error(
    get_citation(polymod_doi, verbose = FALSE),
    "did not return a citation"
  )
  expect_false(inherits(err, "contactsurveys_transient_error"))

  # a gateway page, which has no status to report, and an empty reply; bibtex
  # has to start with an entry type
  for (reply in c("<!DOCTYPE html><html></html>", "", NA_character_)) {
    local_mocked_bindings(
      get_zenodo = function(...) fake_citation_record(reply)
    )
    expect_error(
      get_citation(polymod_doi, verbose = FALSE),
      "did not return a citation"
    )
  }
})

test_that("get_citation() returns the text of a non-bibtex citation", {
  local_mocked_bindings(
    get_zenodo = function(...) {
      fake_citation_record("Mossong, J. (2020). POLYMOD social contact data.")
    }
  )
  citation <- get_citation(
    "https://doi.org/10.5281/zenodo.3874557",
    style = "apa",
    verbose = FALSE
  )
  expect_identical(
    citation,
    "Mossong, J. (2020). POLYMOD social contact data."
  )
})
