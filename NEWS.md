# contactsurveys (development version)

* Added NEWS file
* Added verbosity to `list_surveys()`
* Added `get_citation()` - Resolves #38
* Added bibtex citation style as default to `get_citation()` - Resolves #52
* Fixed verbosity issue by importing purrr::quietly - Resolves #68
* Improved cache management by avoiding unnecessary Zenodo API calls by storing each survey in a subdirectory named after the survey’s DOI/URL basename — Resolves #72
* Added `rate` argument to `download_survey()` and `list_surveys()` to allow for retrying download if it fails, in a sensible fashion, using `purrr::insistently()` - Resolves #72
