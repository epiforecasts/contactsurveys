# Claude Code Instructions for contactsurveys

This package handles all interaction with the Zenodo repository of social contact
surveys — listing, downloading, caching and citing them. Most changes touch a
remote API, file IO, or the cache, and the conventions below exist because those
three are where it breaks.

## Development Workflow

### Before committing
1. Run `devtools::test()` to ensure all tests pass
2. Run `devtools::document()` to regenerate documentation from roxygen comments.
   This also regenerates `R/globals.R` via roxyglobals — never edit that file by
   hand
3. Run `lintr::lint_package()` to check for style issues (fix any in files you
   modified). Formatting is air's job, not yours — `air.yaml` suggests it on the
   PR
4. Add a news entry to NEWS.md under the development version for any user-visible
   change, referencing the issue it closes
5. Add tests for bug fixes (regression tests) or new features where appropriate

### Tests must run offline and on CRAN
The suite must never depend on a live Zenodo call.

- Network calls go behind **vcr cassettes** in `tests/testthat/_vcr/`. `setup.R`
  configures vcr with `record = "new_episodes"`, so a real call is attempted and
  a recorded one used when it fails — a new cassette appears when you add a call
  covering a new request
- Gate anything that can still reach the network with `skip_if_offline()` and
  `skip_on_cran()`
- Downloads are mocked against `tests/testthat/fixtures/`
- `setup.R` points `CONTACTSURVEYS_HOME` at a temp directory for the whole suite;
  a test must never write to the user's real cache
- **Snapshot tests** (`tests/testthat/_snaps/`) are regenerated only when the
  message they capture legitimately changes. Regenerating one to make a failure
  go away hides the regression it just caught

### Where files are written
`tempdir()` is the default and must stay the default. Writes under
`tools::R_user_dir()` — `contactsurveys_dir()`, overridable with the
`CONTACTSURVEYS_HOME` environment variable — must stay opt-in and actively
managed. CRAN policy forbids populating a user directory on first use, and a
change that does so will fail the submission.

### Input validation
Inputs from outside the package are guarded by the `check_*()` helpers, which
`cli::cli_abort(..., call = ...)` so the error points at the caller. A new entry
point taking external input validates the same way, rather than failing deep in a
Zenodo or file call with an opaque message.

### Backwards compatibility
- Only functions exported in a previous CRAN release require deprecation warnings
- Changes between releases (i.e. in the development version) don't require
  deprecation
- NEWS.md entries for unreleased changes can be freely edited or consolidated

### Branching
- Always create a feature branch for changes (never commit directly to main)
- Use descriptive branch names (e.g. `fix-doi-parsing`, `add-cache-manifest`)

### Commit conventions
- Write one-sentence commit messages (detail goes in the PR description)
- When AI assists with code, indicate this with a bot co-author (e.g.
  `Co-authored-by: username-bot <email>`)
- Issue numbers belong in PR descriptions, not commit messages
- Keep commits focused — one logical change per commit

### Pull requests
- Reference the issue being addressed (e.g. "Fixes #123")
- Provide detailed explanation in the PR description, not the commit message
- Do not include "Generated with Claude Code" or test plans in PR descriptions
