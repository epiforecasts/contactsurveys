# Download a survey from its Zenodo repository

Downloads survey data. Uses a caching mechanism via the default argument
for `directory`.

## Usage

``` r
download_survey(
  survey,
  directory = contactsurveys_dir(),
  verbose = TRUE,
  overwrite = FALSE,
  timeout = 3600,
  rate = purrr::rate_backoff(pause_base = 5, max_times = 4)
)
```

## Arguments

- survey:

  A DOI of a survey, (see
  [`list_surveys()`](http://epiforecasts.io/contactsurveys/reference/list_surveys.md)).
  If a HTML link is given, the DOI will be isolated and used.

- directory:

  Directory of where to save survey files. The default value is to use
  the directory for your system using
  [`contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/contactsurveys_dir.md),
  which uses
  [`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html), and
  appends the survey URL/DOI basename as a new directory. E.g., if you
  provide in the `survey` argument, "10.5281/zenodo.1095664", it will
  save the surveys into a directory `zenodo.1095664` under
  [`contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/contactsurveys_dir.md)
  This effectively caches the data. You can specify your own directory,
  or set an environment variable, `CONTACTSURVEYS_HOME`, see
  [`Sys.setenv()`](https://rdrr.io/r/base/Sys.setenv.html) or
  [Renviron](https://rdrr.io/r/base/Startup.html) for more detail. If
  this argument is set to something other than
  [`contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/contactsurveys_dir.md),
  a warning is issued to discourage unnecessary downloads outside the
  persistent cache. Note that identical content accessed via different
  identifiers (e.g., DOI vs. a resolved record URL) will be cached in
  separate directories by design.

- verbose:

  Whether downloads should be echoed to output. Default TRUE.

- overwrite:

  If files should be overwritten if they already exist. Default FALSE

- timeout:

  A numeric value specifying timeout in seconds. Default 3600 seconds.

- rate:

  a [purrr
  rate](https://purrr.tidyverse.org/reference/rate-helpers.html) object,
  to facilitate downloading if the download fails. Defaults to an
  exponential backoff of 5 seconds (up to 4 attempts: 1 initial + 3
  retries) changed by specifying your own rate object, see
  `?purrr::rate_backoff()` for details.

## Value

a vector of filenames, where the surveys were downloaded

## See also

[`list_surveys()`](http://epiforecasts.io/contactsurveys/reference/list_surveys.md)

## Examples

``` r
if (FALSE) { # \dontrun{
list_surveys()
peru_survey <- download_survey("https://doi.org/10.5281/zenodo.1095664")
} # }
```
