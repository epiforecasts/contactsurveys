# Changelog

## contactsurveys 0.1.0

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
