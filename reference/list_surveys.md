# List all surveys available for download

List all surveys available for download

## Usage

``` r
list_surveys(
  directory = tempdir(),
  overwrite = FALSE,
  verbose = TRUE,
  rate = purrr::rate_backoff(pause_base = 5, max_times = 4)
)
```

## Arguments

- directory:

  Directory to save the cached survey list. Defaults to
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html), so the cached
  list does not persist across R sessions. For persistent caching, pass
  [`contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/contactsurveys_dir.md).

- overwrite:

  If files should be overwritten if they already exist. Default FALSE

- verbose:

  Whether downloads should be echoed to output. Default TRUE.

- rate:

  a [purrr
  rate](https://purrr.tidyverse.org/reference/rate-helpers.html) object,
  to facilitate downloading if the download fails. Defaults to an
  exponential backoff of 5 seconds (up to 4 attempts: 1 initial + 3
  retries) changed by specifying your own rate object, see
  `?purrr::rate_backoff()` for details.

## Value

data.table with columns: date_added, title, creator, url

## Examples

``` r
if (FALSE) { # \dontrun{
list_surveys()
} # }
```
