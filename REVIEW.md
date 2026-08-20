# Reviewing a change to contactsurveys

What to look for in a change to contactsurveys specifically — it handles
all interaction with the Zenodo repository of social contact surveys
(listing, downloading, caching, and citing them), so most changes touch
remote APIs, file IO, or the cache. The reviewing method — scoping, the
finding bar, reporting and suggestion mechanics, trust — is the org half
of this spec (`epiforecasts/.github` → `REVIEW.md`), and a review
follows both. The package’s own conventions — offline tests,
documenting, NEWS entries, where files may be written — are in
`CLAUDE.md`; read it too, and flag a change that skips them.

## What to look for

- **Remote-data handling (`zen4R`, `oai`)**: responses treated as a
  shape the API does not guarantee — a record with no files, an empty
  file list, or a Zenodo record that links a published journal article
  so its DOI is not the dataset DOI (the failure behind \#145; the
  survey URL comes from the OAI record identifier, not a positional
  column). Retry/backoff via
  [`purrr::insistently`](https://purrr.tidyverse.org/reference/insistently.html)
  that could turn a permanent failure into a slow one, or hide it
  entirely.
- **File IO and cache robustness**:
  [`file.exists()`](https://rdrr.io/r/base/files.html) on a zero-length
  vector or `NULL` when a download yields no files (it returns
  `logical(0)` or errors rather than `FALSE`); the
  manifest/completion-marker logic in
  [`download_survey()`](http://epiforecasts.io/contactsurveys/reference/download_survey.md)
  treating a partial or interrupted download as complete; `overwrite`
  honoured on every path. Where files land is the `directory` argument —
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) by default,
  [`contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/contactsurveys_dir.md)
  for the persistent cache.
- **DOI / URL parsing
  ([`is_doi()`](http://epiforecasts.io/contactsurveys/reference/is_doi.md),
  `clean_doi()`, `check_is_url_doi()`)**: a bare DOI, a
  `https://doi.org/…` URL, a `doi:` prefix, a trailing `#fragment`,
  surrounding whitespace, or case differences should all normalise to
  the same survey.
- **CRAN policy on user directories**: writes under
  [`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html)
  ([`contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/contactsurveys_dir.md))
  must stay opt-in and actively managed, and the default must not
  populate a user cache on first use —
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html) is the safe
  default. Flag a change that writes to a persistent user directory by
  default.
- **Input validation**: inputs from outside the package are guarded by
  `check_*()` helpers that `cli::cli_abort(..., call = ...)` with a
  clear message; a new entry point taking external input should validate
  the same way rather than failing deep in a Zenodo or file call.
- **Fixtures regenerated to silence a failure**: a changed `_snaps/`
  snapshot or a re-recorded `_vcr/` cassette is how a real regression
  gets papered over. Either is fine when the behaviour legitimately
  changed, and worth questioning when it arrives alongside a fix for
  something else.
