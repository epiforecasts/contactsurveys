test_that("surveys can be downloaded with download_survey()", {
  vcr::local_cassette("download-survey")
  # Mock download.file to use fixtures instead of real downloads
  local_mocked_bindings(download.file = mock_download_file, .package = "utils")

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
  # Mock download.file to use fixtures instead of real downloads
  local_mocked_bindings(download.file = mock_download_file, .package = "utils")

  doi_peru <- "10.5281/zenodo.1095664" # nolint
  # First download (uses vcr cassette + mocked download.file)
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
  # Mock download.file to use fixtures instead of real downloads
  local_mocked_bindings(download.file = mock_download_file, .package = "utils")

  doi_peru <- "10.5281/zenodo.1095664" # nolint
  expect_silent(
    . <- download_survey(doi_peru, verbose = FALSE) # nolint
  )
})

test_that("multiple DOI's cannot be loaded", {
  # This error is thrown before any API call
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

# A stand-in for a zen4R record, so an incomplete download can be simulated
# without the network: `files` is what the record lists, `arriving` what the
# download leaves on disk
fake_record <- function(files, arriving = files) {
  list(
    files = stats::setNames(vector("list", length(files)), files),
    downloadFiles = function(path, overwrite = TRUE, timeout = 60) {
      for (file in arriving) {
        writeLines("part_id,cnt_age", file.path(path, file))
      }
      invisible(NULL)
    },
    metadata = list(
      title = "A survey",
      creators = list(list(person_or_org = list(name = "Surveyor, A"))),
      publication_date = as.Date("2020-01-01")
    ),
    getDOI = function() "10.5281/zenodo.1095664" # nolint
  )
}

test_that("download_survey() errors on an incomplete download", {
  doi_peru <- "10.5281/zenodo.1095664" # nolint
  survey_files <- c(
    "2015_Grijalva_Peru_participant_common.csv",
    "2015_Grijalva_Peru_contact_common.csv",
    "2015_Grijalva_Peru_sday.csv"
  )
  directory <- withr::local_tempdir()
  survey_dir <- file.path(directory, "zenodo.1095664")

  # one of the record's files does not make it onto disk
  partial_download <- function() {
    local_mocked_bindings(
      get_zenodo = function(...) fake_record(survey_files, survey_files[-2])
    )
    # the error is checked on .download_survey(), as download_survey() wraps it
    # in purrr::insistently(), which reports the retries rather than the cause
    suppressMessages(.download_survey(doi_peru, directory = directory))
  }

  expect_error(partial_download(), "2015_Grijalva_Peru_contact_common.csv")

  # the files that did arrive are kept, but the download is not recorded as
  # complete, so the next call retries it rather than serving a truncated cache
  expect_setequal(list.files(survey_dir), survey_files[-2])
  expect_false(file.exists(file.path(survey_dir, ".contactsurveys_files.txt")))
  expect_false(file.exists(file.path(survey_dir, ".contactsurveys_complete")))

  # once every file arrives the download succeeds and is cached as complete
  local_mocked_bindings(get_zenodo = function(...) fake_record(survey_files))
  peru_survey_files <- download_survey(
    doi_peru,
    directory = directory,
    verbose = FALSE
  )
  expect_setequal(
    basename(peru_survey_files),
    c(survey_files, "reference.json")
  )
  expect_true(all(file.exists(peru_survey_files)))
  expect_true(file.exists(file.path(survey_dir, ".contactsurveys_complete")))
})

test_that("download_survey() re-downloads if a manifest has no survey file", {
  doi_peru <- "10.5281/zenodo.1095664" # nolint
  survey_files <- c(
    "2015_Grijalva_Peru_participant_common.csv",
    "2015_Grijalva_Peru_contact_common.csv"
  )
  directory <- withr::local_tempdir()
  survey_dir <- file.path(directory, "zenodo.1095664")
  dir.create(survey_dir, recursive = TRUE)

  # a cache left behind by an earlier incomplete download: marked complete,
  # but the manifest names nothing but the reference JSON
  file.create(file.path(survey_dir, "reference.json"))
  writeLines(
    "reference.json",
    file.path(survey_dir, ".contactsurveys_files.txt")
  )
  file.create(file.path(survey_dir, ".contactsurveys_complete"))

  local_mocked_bindings(get_zenodo = function(...) fake_record(survey_files))
  peru_survey_files <- download_survey(
    doi_peru,
    directory = directory,
    verbose = FALSE
  )
  expect_setequal(
    basename(peru_survey_files),
    c(survey_files, "reference.json")
  )
  expect_true(all(file.exists(peru_survey_files)))
})

test_that("download_survey() writes a manifest for files already on disk", {
  doi_peru <- "10.5281/zenodo.1095664" # nolint
  survey_files <- c(
    "2015_Grijalva_Peru_participant_common.csv",
    "2015_Grijalva_Peru_contact_common.csv"
  )
  directory <- withr::local_tempdir()
  survey_dir <- file.path(directory, "zenodo.1095664")
  dir.create(survey_dir, recursive = TRUE)
  file.create(file.path(survey_dir, survey_files))

  local_mocked_bindings(get_zenodo = function(...) fake_record(survey_files))
  peru_survey_files <- download_survey(
    doi_peru,
    directory = directory,
    verbose = FALSE
  )
  expect_setequal(
    basename(peru_survey_files),
    c(survey_files, "reference.json")
  )
  expect_setequal(
    readLines(file.path(survey_dir, ".contactsurveys_files.txt")),
    c(survey_files, "reference.json")
  )
})

test_that("download_survey() errors if the record lists no files", {
  doi_peru <- "10.5281/zenodo.1095664" # nolint
  directory <- withr::local_tempdir()
  survey_dir <- file.path(directory, "zenodo.1095664")

  local_mocked_bindings(get_zenodo = function(...) fake_record(character(0)))
  expect_error(
    suppressMessages(.download_survey(doi_peru, directory = directory)),
    "lists no files"
  )
  expect_false(file.exists(file.path(survey_dir, ".contactsurveys_complete")))
})

test_that("download_survey() drops the manifest when a re-download fails", {
  doi_peru <- "10.5281/zenodo.1095664" # nolint
  survey_files <- c(
    "2015_Grijalva_Peru_participant_common.csv",
    "2015_Grijalva_Peru_contact_common.csv"
  )
  added_file <- "2015_Grijalva_Peru_sday.csv"
  directory <- withr::local_tempdir()
  survey_dir <- file.path(directory, "zenodo.1095664")

  # a complete download, cached
  local_mocked_bindings(get_zenodo = function(...) fake_record(survey_files))
  download_survey(doi_peru, directory = directory, verbose = FALSE)
  expect_true(file.exists(file.path(survey_dir, ".contactsurveys_complete")))

  # the record gains a file, which then fails to download
  failed_redownload <- function() {
    local_mocked_bindings(
      get_zenodo = function(...) {
        fake_record(c(survey_files, added_file), survey_files)
      }
    )
    suppressMessages(
      .download_survey(doi_peru, directory = directory, overwrite = TRUE)
    )
  }

  expect_error(failed_redownload(), added_file)

  # the earlier download is no longer recorded as complete, so the next call
  # goes back to Zenodo rather than serving a cache that is missing a file
  expect_false(file.exists(file.path(survey_dir, ".contactsurveys_files.txt")))
  expect_false(file.exists(file.path(survey_dir, ".contactsurveys_complete")))

  local_mocked_bindings(
    get_zenodo = function(...) fake_record(c(survey_files, added_file))
  )
  peru_survey_files <- download_survey(
    doi_peru,
    directory = directory,
    verbose = FALSE
  )
  expect_true(added_file %in% basename(peru_survey_files))
})

test_that("download_survey() reports why a download failed", {
  doi_peru <- "10.5281/zenodo.1095664" # nolint
  directory <- withr::local_tempdir()

  # the retry wrapper reports the attempts; the cause is what the user needs
  local_mocked_bindings(
    get_zenodo = function(...) {
      fake_record(c("a.csv", "b.csv"), "a.csv")
    }
  )
  expect_error(
    download_survey(
      doi_peru,
      directory = directory,
      verbose = FALSE,
      rate = purrr::rate_backoff(pause_base = 0, max_times = 2)
    ),
    "b.csv"
  )
})

test_that("download_survey() rejects malformed input without retrying", {
  # a malformed argument is not something a retry can fix, so it must not go
  # through the backoff
  elapsed <- system.time(
    expect_error(
      download_survey(c("10.5281/zenodo.1095664", "10.5281/zenodo.1127693")),
      "must be a character of length 1"
    )
  )
  expect_lt(elapsed[["elapsed"]], 5)
})
