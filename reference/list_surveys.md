# List all surveys available for download

List all surveys available for download

## Usage

``` r
list_surveys(
  directory = contactsurveys_dir(),
  overwrite = FALSE,
  verbose = TRUE,
  rate = purrr::rate_backoff(pause_base = 5, max_times = 4)
)
```

## Arguments

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
list_surveys()
#> Skipping download
#> ℹ Files already exist at
#>   /home/runner/.local/share/R/contactsurveys/survey_list.rds and `overwrite =
#>   FALSE`
#> ℹ Set `overwrite = TRUE` to force a re-download.
#> Key: <date_added>
#>     date_added
#>         <char>
#>  1: 2017-11-07
#>  2: 2017-12-07
#>  3: 2017-12-22
#>  4: 2018-01-23
#>  5: 2018-09-05
#>  6: 2019-01-24
#>  7: 2019-09-16
#>  8: 2019-10-22
#>  9: 2020-06-03
#> 10: 2020-06-03
#> 11: 2020-09-17
#> 12: 2020-10-12
#> 13: 2020-10-16
#> 14: 2020-12-02
#> 15: 2021-05-20
#> 16: 2021-05-25
#> 17: 2021-06-29
#> 18: 2021-06-29
#> 19: 2021-06-29
#> 20: 2021-06-29
#> 21: 2021-06-29
#> 22: 2021-07-03
#> 23: 2021-07-26
#> 24: 2021-07-26
#> 25: 2021-08-20
#> 26: 2022-05-10
#> 27: 2022-05-10
#> 28: 2022-08-22
#> 29: 2023-03-13
#> 30: 2024-03-05
#> 31: 2024-07-27
#> 32: 2025-01-30
#> 33: 2025-08-13
#>     date_added
#>                                                                                           title
#>                                                                                          <char>
#>  1:                                                                 POLYMOD social contact data
#>  2:                                                                Social contact data for Peru
#>  3:                                                                Zimbabwe social contact data
#>  4:                                                                  France social contact data
#>  5:                                                                  Social contact data for UK
#>  6:                              Social contact data for Zambia and South Africa (CODA dataset)
#>  7:                                                              Social contact data for Russia
#>  8:                                                      Social contact data for China mainland
#>  9:                                                           Social contact data for Hong Kong
#> 10:                                                             Social contact data for Vietnam
#> 11:                                                        CoMix social contact data (Belgium )
#> 12:                                     Social contact data before and during COVID-19 in China
#> 13:                                                            Social contact data for Thailand
#> 14:                                                 Social contact data for Belgium (2010-2011)
#> 15:                                                         CoMix social contact data (Austria)
#> 16:                                                     CoMix social contact data (Netherlands)
#> 17:                                                         CoMix social contact data (Denmark)
#> 18:                                                           CoMix social contact data (Italy)
#> 19:                                                        CoMix social contact data (Portugal)
#> 20:                                                          CoMix social contact data (Poland)
#> 21:                                                          CoMix social contact data (France)
#> 22:                                                     Social contact data for the Netherlands
#> 23:                                                          CoMix social contact data (Greece)
#> 24:                                                        CoMix social contact data (Slovenia)
#> 25:                                           Social contact data for IDPs in Somaliland (2019)
#> 26:                                                         CoMix social contact data (Croatia)
#> 27:                                                        CoMix social contact data (Slovakia)
#> 28:                                                               CoMix 2.0 social contact data
#> 29:                               Contact data of older adults (70+) in the Netherlands in 2021
#> 30:        Contact data of Pienter3 (2016-2017) and PiCo (2020-2023) studies in the Netherlands
#> 31:                           Social contact data for the BHDSS and FWHDSS in the Gambia (2022)
#> 32: Social mixing patterns of United States health care personnel at a quaternary health center
#> 33:                                                               Reconnect social contact data
#>                                                                                           title
#>                   creator                                     url
#>                    <char>                                  <char>
#>  1:          Joël Mossong  https://doi.org/10.5281/zenodo.3874557
#>  2:    Carlos G. Grijalva  https://doi.org/10.5281/zenodo.3874805
#>  3:      Alessia Melegaro  https://doi.org/10.5281/zenodo.1251944
#>  4:      Guillaume Béraud  https://doi.org/10.5281/zenodo.1158452
#>  5:   Albert Jan van Hoek  https://doi.org/10.5281/zenodo.3874717
#>  6:         Peter J. Dodd  https://doi.org/10.5281/zenodo.2548693
#>  7:       Maria Litvinova  https://doi.org/10.5281/zenodo.3874674
#>  8:       Zhang, Juanjuan  https://doi.org/10.5281/zenodo.3878615
#>  9:          Kathy  Leung  https://doi.org/10.5281/zenodo.3874808
#> 10:           Horby Peter  https://doi.org/10.5281/zenodo.3874802
#> 11:        Pietro Coletti  https://doi.org/10.5281/zenodo.7788684
#> 12:        Zhang Juanjuan  https://doi.org/10.5281/zenodo.4081140
#> 13:        Mahikul Wiriya  https://doi.org/10.5281/zenodo.4086739
#> 14:         Willem Lander  https://doi.org/10.5281/zenodo.4302055
#> 15:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362906
#> 16:       Backer, Jantien  https://doi.org/10.5281/zenodo.7276465
#> 17:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362899
#> 18:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362888
#> 19:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362887
#> 20:            Gimma, Amy  https://doi.org/10.5281/zenodo.5041129
#> 21:            Gimma, Amy  https://doi.org/10.5281/zenodo.5040871
#> 22: van de Kassteele, Jan  https://doi.org/10.5281/zenodo.5062244
#> 23:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362870
#> 24:            Gimma, Amy  https://doi.org/10.5281/zenodo.5137239
#> 25:  van Zandvoort, Kevin  https://doi.org/10.5281/zenodo.5226281
#> 26:            Gimma, Amy  https://doi.org/10.5281/zenodo.7257433
#> 27:            Gimma, Amy  https://doi.org/10.5281/zenodo.6535357
#> 28:       Coletti, Pietro  https://doi.org/10.5281/zenodo.7331926
#> 29:     Jantien A. Backer  https://doi.org/10.5281/zenodo.7751724
#> 30:       Backer, Jantien https://doi.org/10.5281/zenodo.10370353
#> 31:           Osei, Isaac https://doi.org/10.5281/zenodo.13101862
#> 32:       Pischel, Lauren https://doi.org/10.5281/zenodo.14156576
#> 33:      Goodfellow, Lucy https://doi.org/10.5281/zenodo.17339866
#>                   creator                                     url
```
