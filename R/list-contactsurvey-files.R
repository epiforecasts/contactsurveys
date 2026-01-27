#' List files in contactsurveys cache
#'
#' It can be handy to see which files are available, sometimes to return to
#'  a clean slate and delete them via the `delete_contactsurveys_*()` functions.
#'
#' @param dir Directory to list. Default is [contactsurveys_dir()].
#'
#' @returns Character vector of file paths under `dir` (absolute paths).
#' @seealso [delete_contactsurveys_files()] [delete_survey()]
#'  [delete_contactsurveys_dir()] [download_survey()] [contactsurveys_dir()]
#'
#' @examples
#' ls_contactsurveys()
#' @export
ls_contactsurveys <- function(dir = contactsurveys_dir()) {
  list.files(
    dir,
    full.names = TRUE,
    recursive = TRUE,
    no.. = TRUE,
    all.files = TRUE
  )
}

#' Delete files in contactsurveys directory
#'
#' @param dir directory to list files to delete from
#'
#' @returns nothing, deletes files.
#' @export
#'
#' @rdname delete-files
#' @examplesIf interactive()
#' delete_contactsurveys_files()
delete_contactsurveys_files <- function(dir = contactsurveys_dir()) {
  if (!.dir.exists(dir)) {
    cli::cli_abort(
      c(
        "!" = "Directory not found: {dir}", # nolint
        "i" = "Use {.fun contactsurveys_dir} to get the base path." # nolint
      )
    )
  }
  dir_files <- ls_contactsurveys(dir)
  n_files <- length(dir_files)

  if (n_files == 0) {
    cli::cli_inform(
      message = c(
        "There are no files to delete",
        # nolint start
        "i" = "Use {.fun ls_contactsurveys} to list files in \\
        {.pkg contactsurveys}"
        # nolint end
      )
    )
    return(invisible(NULL))
  }

  if (
    yesno::yesno(
      "Are you sure you want to delete ",
      n_files,
      " many files from ",
      dir,
      "?"
    )
  ) {
    cli::cli_alert_info("Removing {n_files} file{?s} from {dir}")
    removed <- file.remove(dir_files)
    n_removed <- sum(removed, na.rm = TRUE)
    if (n_removed == n_files) {
      cli::cli_alert_success("Removed {n_removed} file{?s} from {dir}")
    } else {
      failed <- dir_files[is.na(removed) | !removed]
      cli::cli_alert_warning(
        "Removed {n_removed} of {n_files} file{?s} from {dir}"
      )
      if (length(failed) > 0) {
        cli::cli_warn(
          c(
            "x" = "Failed to remove:", # nolint
            stats::setNames(failed, rep("*", length(failed)))
          )
        )
      }
    }
  }
  invisible(NULL)
}

#' @name delete-files
#' @export
delete_contactsurveys_dir <- function(dir = contactsurveys_dir()) {
  n_removed <- delete_contactsurveys_files(dir)
  invisible(n_removed)
}


#' Delete files for a given survey
#'
#' For when you want to delete files associated with a given survey.
#'
#' @param survey Survey, as used in [download_survey()].
#'
#' @returns nothing, deleted files
#'
#' @seealso [delete_contactsurveys_dir()] [delete_contactsurveys_files()]
#' @examplesIf interactive()
#' peru_doi <- "https://doi.org/10.5281/zenodo.1095664"
#' delete_survey(peru_doi)
#' @export
delete_survey <- function(survey) {
  check_survey_is_length_one(survey)

  survey_dir <- file.path(contactsurveys_dir(), clean_doi(survey))

  delete_contactsurveys_dir(survey_dir)
}
