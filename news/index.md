# Changelog

## contactsurveys 0.2.0

- [`download_survey()`](http://epiforecasts.io/contactsurveys/reference/download_survey.md)
  now also stores a `reference.json` file alongside the downloaded
  survey files, holding the survey’s title, authors, year, version and
  DOI, so downstream tools can cite the survey without a further Zenodo
  query
  ([\#130](https://github.com/epiforecasts/contactsurveys/issues/130)).

- [`download_survey()`](http://epiforecasts.io/contactsurveys/reference/download_survey.md)
  no longer warns when saving to a directory other than
  [`contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/contactsurveys_dir.md).
  Where files are saved and whether they persist is controlled by, and
  documented on, the `directory` argument, so the warning was redundant
  — and it previously fired even on the default
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html)
  ([\#142](https://github.com/epiforecasts/contactsurveys/issues/142)).

- Fixed
  [`list_surveys()`](http://epiforecasts.io/contactsurveys/reference/list_surveys.md)
  returning a non-Zenodo DOI for surveys whose Zenodo record links a
  published journal article, which caused
  [`download_survey()`](http://epiforecasts.io/contactsurveys/reference/download_survey.md)
  to fail. The survey URL and version ordering are now derived from the
  OAI header identifier, so results do not depend on the order in which
  Zenodo lists a record’s metadata identifiers. Resolves
  [\#145](https://github.com/epiforecasts/contactsurveys/issues/145)

## contactsurveys 0.1.0

CRAN release: 2026-01-31

This is a new package split off from the
[socialmixr](https://github.com/epiforecasts/socialmixr) package. It
handles all interaction with the Zenodo repository containing social
contact surveys, including listing available data sets, downloading data
sets, and obtaining citations.

- Added NEWS file
- Added verbosity to
  [`list_surveys()`](http://epiforecasts.io/contactsurveys/reference/list_surveys.md)
- Added
  [`get_citation()`](http://epiforecasts.io/contactsurveys/reference/get_citation.md) -
  Resolves
  [\#38](https://github.com/epiforecasts/contactsurveys/issues/38)
- Added bibtex citation style as default to
  [`get_citation()`](http://epiforecasts.io/contactsurveys/reference/get_citation.md) -
  Resolves
  [\#52](https://github.com/epiforecasts/contactsurveys/issues/52)
- Fixed verbosity issue by importing purrr::quietly - Resolves
  [\#68](https://github.com/epiforecasts/contactsurveys/issues/68)
- Improved cache management by avoiding unnecessary Zenodo API calls by
  storing each survey in a subdirectory named after the survey’s DOI/URL
  basename — Resolves
  [\#72](https://github.com/epiforecasts/contactsurveys/issues/72)
- Added `rate` argument to
  [`download_survey()`](http://epiforecasts.io/contactsurveys/reference/download_survey.md)
  and
  [`list_surveys()`](http://epiforecasts.io/contactsurveys/reference/list_surveys.md)
  to allow for retrying download if it fails, in a sensible fashion,
  using
  [`purrr::insistently()`](https://purrr.tidyverse.org/reference/insistently.html) -
  Resolves
  [\#72](https://github.com/epiforecasts/contactsurveys/issues/72)
- Added helpers to list and delete files and directories under
  [`contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/contactsurveys_dir.md)
  ({[`ls_contactsurveys()`](http://epiforecasts.io/contactsurveys/reference/ls_contactsurveys.md)},
  `{delete_contactsurveys_files()}`, `{delete_contactsurveys_dir()}`,
  `{delete_survey()}`). Resolves
  [\#75](https://github.com/epiforecasts/contactsurveys/issues/75),
  [\#76](https://github.com/epiforecasts/contactsurveys/issues/76),
  [\#77](https://github.com/epiforecasts/contactsurveys/issues/77)
