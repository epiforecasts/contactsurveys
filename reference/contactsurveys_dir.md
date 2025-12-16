# Default directory for persistent storage for contact surveys

Use `contactsurveys_dir()` to view the default storage location for
files that are downloaded. The
[`download_survey()`](http://epiforecasts.io/contactsurveys/reference/download_survey.md)
function downloads files into `contactsurveys_dir()`. This uses a
directory that is specific to your operating system, powered by the base
function, [`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html).
You can override this by setting an environment variable,
`CONTACTSURVEYS_HOME`. The functions
[`list_surveys()`](http://epiforecasts.io/contactsurveys/reference/list_surveys.md)
and
[`download_survey()`](http://epiforecasts.io/contactsurveys/reference/download_survey.md)
will use this default directory. You can also specify the `directory`
argument in these functions in place of the default value,
`contactsurveys_dir()`. This approach has been borrowed from Carl
Boettiger's `neonstore` R package.

## Usage

``` r
contactsurveys_dir()
```

## Value

the active `contactsurveys` directory.

## Examples

``` r
contactsurveys_dir()
#> [1] "/home/runner/.local/share/R/contactsurveys"

## Override with an environment variable:
Sys.setenv(CONTACTSURVEYS_HOME = tempdir())
contactsurveys_dir()
#> [1] "/tmp/RtmpMWQM2Y"
## Unset
Sys.unsetenv("CONTACTSURVEYS_HOME")
```
