#' Download a survey from its Zenodo repository
#'
#' @description Downloads survey data. Uses a caching mechanism via the default
#'   argument for `directory`.
#'
#' @param survey A DOI of a survey, (see [list_surveys()]). If a HTML link is
#'   given, the DOI will be isolated and used.
#' @param directory Directory of where to save survey files. Defaults to
#'   [tempdir()], so files do not persist across R sessions. For persistent
#'   caching, pass [contactsurveys_dir()], which uses [tools::R_user_dir()]
#'   and appends the survey URL/DOI basename as a subdirectory. E.g., if you
#'   provide "10.5281/zenodo.1095664" in the `survey` argument, it will save
#'   the surveys into a directory `zenodo.1095664` under
#'   `contactsurveys_dir()`. You can also set an environment variable,
#'   `CONTACTSURVEYS_HOME`, see [Sys.setenv()] or [Renviron] for more detail.
#' @param verbose Whether downloads should be echoed to output. Default TRUE.
#' @param overwrite If files should be overwritten if they already exist.
#'   Default FALSE
#' @param timeout A numeric value specifying timeout in seconds. Default
#'   3600 seconds.
#' @param rate a
#'   [purrr rate](https://purrr.tidyverse.org/reference/rate-helpers.html)
#'   object, governing how a download that failed for a reason a retry can fix
#'   is retried: an incomplete download, or a Zenodo request that failed with a
#'   server error or a rate limit. Any other failure is reported as it happened,
#'   without retrying. Defaults to an exponential backoff of 5 seconds (up to 4
#'   attempts: 1 initial + 3 retries) changed by specifying your own rate
#'   object, see `?purrr::rate_backoff()` for details.
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
#' @importFrom jsonlite toJSON
#' @export
download_survey <- function(
  survey,
  directory = tempdir(),
  verbose = TRUE,
  overwrite = FALSE,
  timeout = 3600,
  rate = purrr::rate_backoff(pause_base = 5, max_times = 4)
) {
  # validated before the retry loop, as no amount of retrying makes a malformed
  # argument work
  check_survey_is_length_one(survey)
  survey <- clean_doi(survey)
  check_is_url_doi(survey)

  # only a failure classed as transient is retried; anything else is reported as
  # it happened, so what reaches the user is the error itself rather than a
  # count of the attempts made
  attempt_download <- .download_survey
  if (!isTRUE(verbose)) {
    quiet_download_survey <- purrr::quietly(.download_survey)
    attempt_download <- function(...) quiet_download_survey(...)$result
  }

  transient <- NULL
  purrr::rate_reset(rate)
  repeat {
    # rate_sleep() waits between attempts and errors once they are used up
    attempts_left <- tryCatch(
      {
        purrr::rate_sleep(rate, quiet = !isTRUE(verbose))
        TRUE
      },
      purrr_error_rate_excess = function(condition) FALSE
    )
    if (!attempts_left) {
      break
    }
    result <- tryCatch(
      attempt_download(
        survey = survey,
        directory = directory,
        overwrite = overwrite,
        timeout = timeout
      ),
      contactsurveys_transient_error = function(condition) condition
    )
    if (!inherits(result, "condition")) {
      return(result)
    }
    transient <- result
  }

  if (is.null(transient)) {
    cli::cli_abort("{.arg rate} allowed no attempt at downloading {.val {survey}}.") # nolint
  }
  # the failure that was retried, rather than a count of the retries
  rlang::cnd_signal(transient)
}

#' @autoglobal
#' @note internal
.download_survey <- function(
  survey,
  directory = tempdir(),
  overwrite = FALSE,
  timeout = 60
) {
  check_survey_is_length_one(survey)

  survey <- clean_doi(survey)

  check_is_url_doi(survey)

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
    # a manifest naming nothing but the reference JSON was written by a version
    # that recorded an incomplete download as complete (#159); re-download
    # rather than serve it
    has_survey_files <- !all(endsWith(manifest_files, "reference.json"))
    all_files_exist <- length(manifest_paths) > 0 &&
      has_survey_files &&
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

  check_record_is_downloadable(records, survey_url)

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
    existing <- sort(zenodo_files(survey_dir, records))

    # Include reference JSON file
    reference_file_path <- store_reference(records, survey_dir)
    existing <- sort(c(existing, reference_file_path))

    # (re-)write the manifest for next time, so a manifest left behind by an
    # incomplete download is replaced once the files are all there
    writeLines(basename(existing), files_manifest)
    file.create(complete_marker)
    existing
  } else {
    cli::cli_inform("Downloading from {survey_url}.")

    # from here the cache is no longer complete, whatever it held before: drop
    # the markers so an interrupted download cannot leave a stale manifest that
    # the next call would trust
    unlink(c(files_manifest, complete_marker))
    records$downloadFiles(
      path = survey_dir,
      overwrite = overwrite,
      timeout = timeout
    )

    # An incomplete download is a failure: erroring here lets the retry in
    # download_survey() fetch the missing files, and leaves the manifest and
    # completion marker unwritten so a partial download is never cached as a
    # complete one
    missing_files <- missing_zenodo_files(survey_dir, records)
    if (length(missing_files) > 0) {
      cli::cli_abort(
        message = c(
          "Download from {survey_url} was incomplete.",
          "x" = "{cli::qty(missing_files)}Missing file{?s}: {.file {missing_files}}", # nolint
          "i" = "The record lists {length(records$files)} file{?s}." # nolint
        ),
        class = "contactsurveys_transient_error"
      )
    }

    downloaded <- sort(zenodo_files(survey_dir, records))

    # Include reference JSON file
    reference_file_path <- store_reference(records, survey_dir)
    downloaded <- sort(c(downloaded, reference_file_path))

    # Write the files that were downloaded into the manifest as a completion
    # marker for offline cache hits
    writeLines(
      text = basename(downloaded),
      con = files_manifest
    )
    file.create(complete_marker)
    downloaded
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

#' Extracts meta-data and repository info from a zen4R::ZenodoRecord object
#'
#' @param records ZenodoRecord object; the object to parse information from
#' @param survey_dir file path; location to store the meta-data file
#' @return file path; file path to the JSON file with meta-data and link(s)
#' @note internal
#' @importFrom jsonlite toJSON
store_reference <- function(records, survey_dir) {
  reference <- list(
    title = records$metadata$title,
    bibtype = "Misc",
    author = vapply(
      records$metadata$creators,
      function(x) {
        person_or_org <- x$person_or_org
        name <- person_or_org$name
        if (is.null(name)) {
          name <- toString(
            c(person_or_org$family_name, person_or_org$given_name)
          )
        }
        name
      },
      character(1)
    ),
    year = data.table::year(records$metadata$publication_date)
  )
  if ("version" %in% names(records$metadata)) {
    reference[["note"]] <- paste("Version", records$metadata$version)
  }
  if ("references" %in% names(records$metadata)) {
    reference[["reference"]] <- unlist(
      records$metadata$references,
      use.names = FALSE
    )
  }
  reference[["doi"]] <- records$getDOI()

  # file name
  survey_files <- names(records$files)
  dictionary_files <- survey_files[grepl(
    "dictionary",
    survey_files,
    ignore.case = TRUE
  )]
  prefix <- if (length(dictionary_files) >= 1) {
    basename(gsub(
      "dictionary.*",
      "",
      dictionary_files[[1]]
    ))
  } else {
    ""
  }
  reference_file_path <- file.path(survey_dir, paste0(prefix, "reference.json"))

  # Store JSON file
  reference_json <- toJSON(reference)
  write(reference_json, reference_file_path)

  reference_file_path
}
