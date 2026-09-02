#' Paths to the files a Zenodo record lists
#'
#' For use inside [download_survey()].
#'
#' @param directory A single string specifying the directory path.
#' @param records A records object with a `files` component.
#' @noRd
#' @note internal
#'
#' @returns A character vector of the paths the record's files would have in
#'   `directory`, whether or not they are there
zenodo_file_paths <- function(directory, records) {
  file.path(directory, names(records$files))
}

#' Names of the record's files that are not in `directory`
#'
#' @inheritParams zenodo_file_paths
#' @noRd
#' @note internal
#'
#' @returns A character vector of file names, empty if the download is complete
missing_zenodo_files <- function(directory, records) {
  paths <- zenodo_file_paths(directory, records)
  basename(paths[!file.exists(paths)])
}

#' Check whether every file of a Zenodo record is in `directory`
#'
#' @inheritParams zenodo_file_paths
#' @noRd
#' @note internal
#'
#' @returns TRUE/FALSE indicating whether all files exist
zenodo_files_exist <- function(directory, records) {
  length(missing_zenodo_files(directory, records)) == 0L
}

#' Paths to the files of a Zenodo record that are in `directory`
#'
#' Returns the subset that is present, so a partial download keeps the files it
#' did get and the caller can tell what is missing.
#'
#' @inheritParams zenodo_file_paths
#' @noRd
#' @note internal
#'
#' @returns A character vector of existing file paths
zenodo_files <- function(directory, records) {
  paths <- zenodo_file_paths(directory, records)
  paths[file.exists(paths)]
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
