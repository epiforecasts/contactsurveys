# contactsurveys (development version)

* Added NEWS file
* Added verbosity to `list_surveys()`
* Added `get_citation()` - Resolves #38
* Added bibtex citation style as default to `get_citation()` - Resolves #52
* Fixed verbosity issue by importing purrr::quietly - Resolves #68
* Improved cache management by avoiding the need to query the zenodo API at all by storing surveys inside a folder named after the survey name - Resolves #72
