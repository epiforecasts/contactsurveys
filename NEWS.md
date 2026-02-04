# contactsurveys (development version)

# contactsurveys 0.1.0

This is a new package split off from the `{socialmixr}` package. It handles all interaction with the Zenodo repository containing social contact surveys, including listing available data sets, downloading data sets, and obtaining citations.

- Added NEWS file
- Added verbosity to `list_surveys()`
- Added `get_citation()` - Resolves #38
- Added bibtex citation style as default to `get_citation()` - Resolves #52
- Fixed verbosity issue by importing purrr::quietly - Resolves #68
- Improved cache management by avoiding unnecessary Zenodo API calls by storing each survey in a subdirectory named after the survey’s DOI/URL basename — Resolves #72
- Added `rate` argument to `download_survey()` and `list_surveys()` to allow for retrying download if it fails, in a sensible fashion, using `purrr::insistently()` - Resolves #72
- Added helpers to list and delete files and directories under `contactsurveys_dir()` ({`ls_contactsurveys()`}, `{delete_contactsurveys_files()}`, `{delete_contactsurveys_dir()}`, `{delete_survey()}`). Resolves #75, #76, #77
