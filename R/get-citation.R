#' Get citation from a DOI
#'
#' This is a wrapper around [zen4R::get_citation()] with a couple of smaller
#' changes. Firstly, it silences output from [zen4R::get_citation()], secondly
#' the default citation style is "apa".
#'
#' @param doi A string, the Zenodo DOI or concept DOI.
#' @param style A string, the citation style. Default is "bibtex". Possible
#'   values are: "bibtex", "harvard-cite-them-right", "apa",
#'   "modern-language-association", "vancouver",
#'   "chicago-fullnote-bibliography", or "ieee".
#' @param verbose logical. Should messages during citation fetching print to
#'   the screen? Default is TRUE.
#'
#' @return A character string containing the citation in the requested style.
#'   For `"bibtex"` style, returns an object of class `"csbib"`.
#' @export
#' @examplesIf is_online()
#' polymod_doi <- "https://doi.org/10.5281/zenodo.3874557"
#' get_citation(polymod_doi)
get_citation <- function(
  doi,
  style = c(
    "bibtex",
    "apa",
    "harvard-cite-them-right",
    "modern-language-association",
    "vancouver",
    "chicago-fullnote-bibliography",
    "ieee"
  ),
  verbose = TRUE
) {
  if (verbose) {
    cli::cli_progress_step(
      msg = "Fetching citation",
      msg_done = "Citation fetched!"
    )
  }

  style <- rlang::arg_match(style)
  doi_citation <- suppressMessages(
    zen4R::get_citation(
      doi = doi,
      style = style
    )
  )

  # add nicer print method for bibtex citation
  if (style == "bibtex") {
    class(doi_citation) <- c("csbib", class(doi_citation))
  }
  doi_citation
}

#' Print a csbib citation
#'
#' @param x A `"csbib"` object.
#' @param ... Additional arguments passed to methods.
#' @return Invisibly returns `x`.
#' @export
print.csbib <- function(x, ...) {
  cat(x, sep = "", "\n")
  invisible(x)
}
