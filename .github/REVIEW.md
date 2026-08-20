# Reviewing a change to contactsurveys

What to look for in a change to contactsurveys specifically — it handles all
interaction with the Zenodo repository of social contact surveys (listing,
downloading, caching, and citing them), so most changes touch remote APIs, file
IO, or the cache. The reviewing method — scoping, the finding bar, reporting and
suggestion mechanics, trust — is the org half of this spec
(`epiforecasts/.github` → `REVIEW.md`), and a review follows both. This package
has no `CLAUDE.md`, so the few conventions worth holding are noted below.

## What to look for

- **Remote-data handling (`zen4R`, `oai`)**: responses treated as a shape the API
  does not guarantee — a record with no files, an empty file list, or a Zenodo
  record that links a published journal article so its DOI is not the dataset
  DOI (the failure behind #145; the survey URL comes from the OAI record
  identifier, not a positional column). Retry/backoff via `purrr::insistently`
  that could turn a permanent failure into a slow one, or hide it entirely.
- **File IO and cache robustness**: `file.exists()` on a zero-length vector or
  `NULL` when a download yields no files (it returns `logical(0)` or errors
  rather than `FALSE`); the manifest/completion-marker logic in
  `download_survey()` treating a partial or interrupted download as complete;
  `overwrite` honoured on every path. Where files land is the `directory`
  argument — `tempdir()` by default, `contactsurveys_dir()` for the persistent
  cache.
- **DOI / URL parsing (`is_doi()`, `clean_doi()`, `check_is_url_doi()`)**: a bare
  DOI, a `https://doi.org/…` URL, a `doi:` prefix, a trailing `#fragment`,
  surrounding whitespace, or case differences should all normalise to the same
  survey.
- **CRAN policy on user directories**: writes under `tools::R_user_dir()`
  (`contactsurveys_dir()`) must stay opt-in and actively managed, and the default
  must not populate a user cache on first use — `tempdir()` is the safe default.
  Flag a change that writes to a persistent user directory by default.
- **Input validation**: inputs from outside the package are guarded by `check_*()`
  helpers that `cli::cli_abort(..., call = ...)` with a clear message; a new
  entry point taking external input should validate the same way rather than
  failing deep in a Zenodo or file call.
- **Tests and conventions**: a regression test for every bug fix; network calls
  exercised behind `vcr` cassettes (`tests/testthat/_vcr/`) and gated with
  `skip_if_offline()` / `skip_on_cran()` so the suite runs offline and on CRAN,
  not against a live call; snapshot tests (`_snaps/`) regenerated only when the
  message they capture legitimately changes; a `NEWS.md` entry under the
  development version for any user-visible change, referencing the issue it
  closes.
