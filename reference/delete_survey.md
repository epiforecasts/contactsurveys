# Delete files for a given survey

For when you want to delete files associated with a given survey.

## Usage

``` r
delete_survey(survey)
```

## Arguments

- survey:

  Survey, as used in
  [`download_survey()`](http://epiforecasts.io/contactsurveys/reference/download_survey.md).

## Value

nothing, deleted files

## See also

[`delete_contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/delete-files.md)
[`delete_contactsurveys_files()`](http://epiforecasts.io/contactsurveys/reference/delete-files.md)

## Examples

``` r
if (FALSE) { # \dontrun{
peru_doi <- "https://doi.org/10.5281/zenodo.1095664"
delete_survey(peru_doi)
} # }
```
