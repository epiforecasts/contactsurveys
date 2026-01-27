# Directory for persistent storage of contact surveys

Returns a platform-specific directory for persistent storage of
downloaded survey files, powered by
[`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html). You can
override this by setting the environment variable `CONTACTSURVEYS_HOME`.

## Usage

``` r
contactsurveys_dir()
```

## Value

the active `contactsurveys` directory.

## Details

By default,
[`download_survey()`](http://epiforecasts.io/contactsurveys/reference/download_survey.md)
and
[`list_surveys()`](http://epiforecasts.io/contactsurveys/reference/list_surveys.md)
use [`tempdir()`](https://rdrr.io/r/base/tempfile.html) so files do not
persist across R sessions. To enable persistent caching, pass
`contactsurveys_dir()` as the `directory` argument, e.g.
`download_survey(survey, directory = contactsurveys_dir())`.

## Examples

``` r
contactsurveys_dir()
#> [1] "/home/runner/.local/share/R/contactsurveys"

## Override with an environment variable:
Sys.setenv(CONTACTSURVEYS_HOME = tempdir())
contactsurveys_dir()
#> [1] "/tmp/RtmpnUA8bQ"
## Unset
Sys.unsetenv("CONTACTSURVEYS_HOME")
```
