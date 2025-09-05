#' List files in contactsurveys cache
#'
#' It can be handy to see which files are available, and sometimes you want to
#' delete them all.
#'
#' @param dir default is [contactsurveys_dir()].
#'
#' @returns files in `dir`
#' @seealso [delete_contactsurveys_files()] [delete_contactsurveys_dir()]
#'  [delete_survey()] [delete_contactsurveys_dir()] [download_survey()]
#'  [contactsurveys_dir()]
#'
#' @examples
#' ls_contactsurveys()
#' @export
ls_contactsurveys <- function(dir = contactsurveys_dir()) {
  dir |>
    list.files(
      full.names = TRUE,
      recursive = TRUE,
      no.. = TRUE
    )
}

delete_contactsurveys_files <- function(dir) {
  dir_files <- ls_contactsurveys(dir)

  n_files <- length(dir_files)

  if (n_files == 0) {
    cli::cli_inform(
      message = c(
        "There are no files to delete",
        "i" = "Use {.fun ls_contactsurveys} to list files in {.pkg contactsurveys}"
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
    file.remove(dir_files)
    cli::cli_alert_success("Removed {n_files} file{?s} from {dir}")
  }
}

delete_survey <- function(survey) {
  check_survey_is_length_one(survey)

  survey <- clean_doi(survey)

  delete_contactsurveys_files(survey)
}

delete_contactsurveys_dir <- function(dir = contactsurveys_dir()) {
  delete_contactsurveys_files(dir)
}
