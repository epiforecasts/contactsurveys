#'
#' For use inside [download_survey()].
#'
#' @param directory A single string specifying the directory path.
#' @param records A records object with a `files` component.
#' @noRd
#' @note internal
#'
#' @returns TRUE/FALSE indicating whether all files exist
zenodo_files_exist <- function(directory, records) {
  the_zenodo_files <- zenodo_files(directory, records)
  if (is.character(the_zenodo_files)) {
    files_exist <- TRUE
  } else if (is.null(the_zenodo_files)) {
    files_exist <- FALSE
  }

  files_exist
}

zenodo_files <- function(directory, records) {
  zenodo_files <- file.path(directory, names(records$files))
  do_all_files_exist <- all(file.exists(zenodo_files))
  if (do_all_files_exist) {
    out <- zenodo_files
  } else {
    out <- NULL
  }
  out
}


#' @note internal
ensure_dir_exists <- function(directory) {
  if (
    !is.character(directory) ||
      length(directory) != 1L ||
      is.na(directory) ||
      !nzchar(directory)
  ) {
    cli::cli_abort(
      message = c(
        "{.arg directory} must be a valid file path.",
        "i" = "We see: {.arg {directory}}" # nolint
      ),
      call = rlang::caller_env()
    )
  }
  directory <- path.expand(directory)
  if (!dir.exists(directory)) {
    ok <- dir.create(
      path = directory,
      showWarnings = FALSE,
      recursive = TRUE
    )
    if (!ok && !dir.exists(directory)) {
      cli::cli_abort(
        "Failed to create directory {.file {directory}}.",
        call = rlang::caller_env()
      )
    }
  }
  invisible(directory)
}

dir_not_empty <- function(directory) {
  the_dir_files <- list.files(
    directory,
    all.files = TRUE,
    include.dirs = FALSE,
    no.. = TRUE
  )
  length(the_dir_files) > 0
}
