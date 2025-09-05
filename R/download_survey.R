#' Download a survey from its Zenodo repository
#'
#' @description Downloads survey data. Uses a caching mechanism via the default
#'   argument for `directory`.
#'
#' @param survey A DOI of a survey, (see [list_surveys()]). If a HTML link is
#'   given, the DOI will be isolated and used.
#' @param directory Directory of where to save survey files. The default value
#'  is to use the directory for your system using [contactsurveys_dir()], which
#'  uses [tools::R_user_dir()], and appends the survey URL/DOI basename as a
#'  new directory. E.g., if you provide in the `survey` argument,
#'  "10.5281/zenodo.1095664", it will save the surveys into a directory
#'  `zenodo.1095664` under `contactsurveys_dir()` This effectively caches
#'  the data. You can specify your own directory, or set an environment
#'  variable, `CONTACTSURVEYS_HOME`, see [Sys.setenv()] or [Renviron] for
#'  more detail. If this argument is set to something other than
#'  [contactsurveys_dir()], a warning is issued to discourage unnecessary
#'   downloads outside the persistent cache. Note that identical content
#'   accessed via different identifiers (e.g., DOI vs. a resolved record URL)
#'   will be cached in separate directories by design.
#' @param verbose Whether downloads should be echoed to output. Default TRUE.
#' @param overwrite If files should be overwritten if they already exist.
#'   Default FALSE
#' @param timeout A numeric value specifying timeout in seconds. Default 3600 seconds.
#' @param rate a
#'   [purrr rate](https://purrr.tidyverse.org/reference/rate-helpers.html)
#'   object, to facilitate downloading if the download fails. Defaults to an
#'   exponential backoff of 5 seconds, retrying only 3 times. This can be
#'   changed by specifying your own rate object, see `?purrr::rate_backoff()`
#'   for details.
#'
#' @return a vector of filenames, where the surveys were downloaded
#'
#' @autoglobal
#' @examples
#' \donttest{
#' list_surveys()
#' peru_survey <- download_survey("https://doi.org/10.5281/zenodo.1095664")
#' }
#' @seealso [list_surveys()]
#' @importFrom zen4R get_zenodo
#' @importFrom
#' @export
download_survey <- function(
  survey,
  directory = contactsurveys_dir(),
  verbose = TRUE,
  overwrite = FALSE,
  timeout = 3600,
  rate = purrr::rate_backoff(pause_base = 5, max_times = 4)
) {
  insistent_download_survey <- purrr::insistently(
    f = .download_survey,
    rate = rate,
    quiet = FALSE
  )
  if (verbose) {
    insistent_download_survey(
      survey = survey,
      directory = directory,
      overwrite = overwrite,
      timeout = timeout
    )
  } else {
    quiet_download_survey <- purrr::quietly(insistent_download_survey)
    quiet_download_survey(
      survey = survey,
      directory = directory,
      overwrite = overwrite,
      timeout = timeout
    )$result
  }
}

#' @autoglobal
#' @note internal
.download_survey <- function(
  survey,
  directory = contactsurveys_dir(),
  overwrite = FALSE,
  timeout = 60
) {
  check_survey_is_length_one(survey)

  survey <- clean_doi(survey)

  check_is_url_doi(survey)

  check_directory(directory)

  if (is_doi(survey)) {
    survey_url <- paste0("https://doi.org/", survey) # nolint
  } else {
    survey_url <- survey # nolint
  }

  survey_dir <- file.path(directory, basename(survey))
  ensure_dir_exists(survey_dir)

  # create a manifest and marker to indicate if a download was successful
  files_manifest <- file.path(survey_dir, ".contactsurveys_files.txt")
  complete_marker <- file.path(survey_dir, ".contactsurveys_complete")
  has_manifest <- file.exists(files_manifest) && file.exists(complete_marker)

  if (!overwrite && has_manifest) {
    manifest_files <- readLines(files_manifest, warn = FALSE)
    manifest_files <- manifest_files[nzchar(manifest_files)]
    manifest_paths <- file.path(survey_dir, manifest_files)
    all_files_exist <- length(manifest_paths) > 0 &&
      all(file.exists(manifest_paths))
    if (all_files_exist) {
      cli::cli_inform(
        c(
          "Skipping download.",
          "i" = "Files already exist, and {.code overwrite = FALSE}", # nolint
          "i" = "Set {.code overwrite = TRUE} to force a re-download." # nolint
        )
      )
      return(sort(manifest_paths))
    }
  }
  cli::cli_inform("Fetching contact survey filenames from: {survey_url}.")
  records <- get_zenodo(survey)

  files_already_exist <- zenodo_files_exist(survey_dir, records)
  do_not_download <- files_already_exist && !overwrite
  if (do_not_download) {
    cli::cli_inform(
      c(
        "Skipping download.",
        "i" = "Files already exist, and {.code overwrite = FALSE}", # nolint
        "i" = "Set {.code overwrite = TRUE} to force a re-download." # nolint
      )
    )
    # if the manifest already exists, write to it for next time
    existing <- sort(zenodo_files(survey_dir, records))
    if (!has_manifest) {
      writeLines(basename(existing), files_manifest)
      file.create(complete_marker)
    }
    return(existing)
  } else {
    cli::cli_inform("Downloading from {survey_url}.")
    records$downloadFiles(
      path = survey_dir,
      overwrite = overwrite,
      timeout = timeout
    )
    downloaded <- sort(zenodo_files(survey_dir, records))
    # Write the files that were downloaded into the manifest as a completion
    # marker for offline cache hits
    writeLines(
      text = basename(downloaded),
      con = file.path(survey_dir, ".contactsurveys_files.txt")
    )
    file.create(file.path(survey_dir, ".contactsurveys_complete"))
    return(downloaded)
  }
}

##' Checks if a character string is a DOI
##'
##' @param x Character vector; the string or strings to check
##' @return Logical; \code{TRUE} if \code{x} is a DOI, \code{FALSE} otherwise
##' @author Sebastian Funk
is_doi <- function(x) {
  is.character(x) && grepl("^10.[0-9.]{4,}/[-._;()/:A-z0-9]+$", x)
}

#' @note internal
clean_doi <- function(x) {
  x <- sub("^(https?:\\/\\/(dx\\.)?doi\\.org\\/|doi:)", "", x)
  x <- sub("#.*$", "", x)
  x
}
