#' Directory for persistent storage of contact surveys
#'
#' Returns a platform-specific directory for persistent storage of downloaded
#' survey files, powered by [tools::R_user_dir()]. You can override this by
#' setting the environment variable `CONTACTSURVEYS_HOME`.
#'
#' By default, [download_survey()] and [list_surveys()] use [tempdir()] so
#' files do not persist across R sessions. To enable persistent caching, pass
#' `contactsurveys_dir()` as the `directory` argument, e.g.
#' `download_survey(survey, directory = contactsurveys_dir())`.
#'
#' @return the active `contactsurveys` directory.
#' @export
#' @examples
#'
#' contactsurveys_dir()
#'
#' ## Override with an environment variable:
#' Sys.setenv(CONTACTSURVEYS_HOME = tempdir())
#' contactsurveys_dir()
#' ## Unset
#' Sys.unsetenv("CONTACTSURVEYS_HOME")
#'
contactsurveys_dir <- function() {
  cs_dir <- Sys.getenv("CONTACTSURVEYS_HOME", unset = NA_character_)
  if (is.na(cs_dir) || !nzchar(cs_dir)) {
    cs_dir <- tools::R_user_dir("contactsurveys")
  }
  cs_dir
}
