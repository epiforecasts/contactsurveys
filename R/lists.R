#' List all surveys available for download
#'
#' @param directory Directory to save the cached survey list. Defaults to
#'   [tempdir()], so the cached list does not persist across R sessions. For
#'   persistent caching, pass [contactsurveys_dir()].
#' @return data.table with columns: date_added, title, creator, url
#' @inheritParams download_survey
#' @importFrom oai list_records
#' @importFrom data.table data.table setkey rbindlist
#' @autoglobal
#' @examplesIf is_online()
#' list_surveys()
#' @export
list_surveys <- function(
  directory = tempdir(),
  overwrite = FALSE,
  verbose = TRUE,
  rate = purrr::rate_backoff(pause_base = 5, max_times = 4)
) {
  insistent_list_surveys <- purrr::insistently(
    f = .list_surveys,
    rate = rate,
    quiet = !isTRUE(verbose)
  )
  if (verbose) {
    insistent_list_surveys(directory = directory, overwrite = overwrite)
  } else {
    quiet_list_surveys <- purrr::quietly(insistent_list_surveys)
    quiet_list_surveys(directory = directory, overwrite = overwrite)$result
  }
}

#' @autoglobal
#' @note internal
.list_surveys <- function(
  directory = tempdir(),
  overwrite = FALSE
) {
  survey_list_path <- file.path(directory, "survey_list.rds")
  survey_list_exists <- file.exists(survey_list_path)
  do_not_download <- survey_list_exists && !overwrite
  if (do_not_download) {
    cli::cli_inform(
      c(
        "Skipping download",
        # nolint start
        "i" = "Files already exist at {.path {survey_list_path}} and \\
        {.code overwrite = FALSE}",
        "i" = "Set {.code overwrite = TRUE} to force a re-download."
        # nolint end
      )
    )
    record_list <- tryCatch(readRDS(survey_list_path), error = function(e) NULL)
    record_list_exists <- !is.null(record_list)
    if (record_list_exists) {
      return(record_list)
    }
    cli::cli_inform("Cached survey_list.rds could not be read; re-downloading.")
    unlink(survey_list_path, force = TRUE)
  }

  cli::cli_progress_step("Downloading survey list from zenodo")
  record_list <-
    data.table(list_records(
      url = "https://zenodo.org/oai2d",
      metadataPrefix = "oai_datacite",
      set = "user-social_contact_data"
    ))
  ## find common DOI for different versions, i.e. the "relation" that is a DOI
  relations <- grep("^relation(\\.|$)", colnames(record_list), value = TRUE)
  DOIs <- apply(
    X = record_list,
    MARGIN = 1,
    FUN = function(x) {
      min(grep("^https://doi.org/.*zenodo", x[relations], value = TRUE))
    }
  )
  record_list <- record_list[, common_doi := DOIs]
  record_list <- record_list[,
    url := sub("doi:", "https://doi.org/", common_doi, fixed = TRUE)
  ]
  ## get number within version DOI, this is expected to be ascending by version
  record_list <-
    record_list[,
      doi.nb := as.integer(sub("^.*zenodo\\.org:", "", identifier.1))
    ]
  ## save date at which first entered
  record_list <- record_list[, date := min(date), by = common_doi]
  ## order by DOI number and extract newest version
  record_list <- record_list[order(-doi.nb)]
  record_list <- record_list[, .SD[1], by = common_doi]
  ## order by date
  setkey(record_list, date)
  record_list <- record_list[, list(
    date_added = date,
    title,
    creator,
    url = identifier.2
  )]

  ensure_dir_exists(directory)
  saveRDS(object = record_list, file = survey_list_path)

  record_list
}
