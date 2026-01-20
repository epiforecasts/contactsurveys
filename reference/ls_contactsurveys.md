# List files in contactsurveys cache

It can be handy to see which files are available, sometimes to return to
a clean slate and delete them via the `delete_contactsurveys_*()`
functions.

## Usage

``` r
ls_contactsurveys(dir = contactsurveys_dir())
```

## Arguments

- dir:

  Directory to list. Default is
  [`contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/contactsurveys_dir.md).

## Value

Character vector of file paths under `dir` (absolute paths).

## See also

[`delete_contactsurveys_files()`](http://epiforecasts.io/contactsurveys/reference/delete-files.md)
[`delete_survey()`](http://epiforecasts.io/contactsurveys/reference/delete_survey.md)
[`delete_contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/delete-files.md)
[`download_survey()`](http://epiforecasts.io/contactsurveys/reference/download_survey.md)
[`contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/contactsurveys_dir.md)

## Examples

``` r
ls_contactsurveys()
#> character(0)
```
