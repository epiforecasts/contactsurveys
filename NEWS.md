# contactsurveys (development version)

- Added a package logo.

# contactsurveys 0.2.0

- `download_survey()` now also stores a `reference.json` file alongside the downloaded survey files, holding the survey's title, authors, year, version and DOI, so downstream tools can cite the survey without a further Zenodo query (#130).

- `download_survey()` no longer warns when saving to a directory other than `contactsurveys_dir()`. Where files are saved and whether they persist is controlled by, and documented on, the `directory` argument, so the warning was redundant — and it previously fired even on the default `tempdir()` (#142).

- Fixed `list_surveys()` returning a non-Zenodo DOI for surveys whose Zenodo record links a published journal article, which caused `download_survey()` to fail. The survey URL and version ordering are now derived from the OAI header identifier, so results do not depend on the order in which Zenodo lists a record's metadata identifiers. Resolves #145

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
