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
#>  [1] "/home/runner/.local/share/R/contactsurveys/survey_list.rds"                                         
#>  [2] "/home/runner/.local/share/R/contactsurveys/zenodo.1095664/.contactsurveys_complete"                 
#>  [3] "/home/runner/.local/share/R/contactsurveys/zenodo.1095664/.contactsurveys_files.txt"                
#>  [4] "/home/runner/.local/share/R/contactsurveys/zenodo.1095664/2015_Grijalva_Peru_contact_common.csv"    
#>  [5] "/home/runner/.local/share/R/contactsurveys/zenodo.1095664/2015_Grijalva_Peru_dictionary.xls"        
#>  [6] "/home/runner/.local/share/R/contactsurveys/zenodo.1095664/2015_Grijalva_Peru_hh_common.csv"         
#>  [7] "/home/runner/.local/share/R/contactsurveys/zenodo.1095664/2015_Grijalva_Peru_hh_extra.csv"          
#>  [8] "/home/runner/.local/share/R/contactsurveys/zenodo.1095664/2015_Grijalva_Peru_participant_common.csv"
#>  [9] "/home/runner/.local/share/R/contactsurveys/zenodo.1095664/2015_Grijalva_Peru_participant_extra.csv" 
#> [10] "/home/runner/.local/share/R/contactsurveys/zenodo.1095664/2015_Grijalva_Peru_sday.csv"              
```
