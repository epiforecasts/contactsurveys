# Download a survey from its Zenodo repository

Downloads survey data. Uses a caching mechanism via the default argument
for `directory`.

## Usage

``` r
download_survey(
  survey,
  directory = tempdir(),
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

  Directory of where to save survey files. Defaults to
  [`tempdir()`](https://rdrr.io/r/base/tempfile.html), so files do not
  persist across R sessions. For persistent caching, pass
  [`contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/contactsurveys_dir.md),
  which uses
  [`tools::R_user_dir()`](https://rdrr.io/r/tools/userdir.html) and
  appends the survey URL/DOI basename as a subdirectory. E.g., if you
  provide "10.5281/zenodo.1095664" in the `survey` argument, it will
  save the surveys into a directory `zenodo.1095664` under
  [`contactsurveys_dir()`](http://epiforecasts.io/contactsurveys/reference/contactsurveys_dir.md).
  You can also set an environment variable, `CONTACTSURVEYS_HOME`, see
  [`Sys.setenv()`](https://rdrr.io/r/base/Sys.setenv.html) or
  [Renviron](https://rdrr.io/r/base/Startup.html) for more detail.

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
# \donttest{
list_surveys()
#> ℹ Downloading survey list from zenodo
#> ✔ Downloading survey list from zenodo [6.1s]
#> 
#> Key: <date_added>
#>     date_added
#>         <char>
#>  1: 2017-11-07
#>  2: 2017-12-07
#>  3: 2017-12-22
#>  4: 2018-01-23
#>  5: 2018-02-05
#>  6: 2018-06-14
#>  7: 2018-09-05
#>  8: 2019-01-24
#>  9: 2019-08-13
#> 10: 2019-09-16
#> 11: 2020-08-06
#> 12: 2020-09-30
#> 13: 2020-09-30
#> 14: 2020-10-12
#> 15: 2020-10-16
#> 16: 2021-05-06
#> 17: 2021-05-20
#> 18: 2021-05-25
#> 19: 2021-06-07
#> 20: 2021-06-29
#> 21: 2021-06-29
#> 22: 2021-06-29
#> 23: 2021-06-29
#> 24: 2021-06-29
#> 25: 2021-06-29
#> 26: 2021-07-03
#> 27: 2021-07-26
#> 28: 2021-07-26
#> 29: 2021-08-20
#> 30: 2022-04-11
#> 31: 2022-05-10
#> 32: 2022-05-10
#> 33: 2022-05-10
#> 34: 2022-05-10
#> 35: 2022-05-12
#> 36: 2022-05-12
#> 37: 2022-05-12
#> 38: 2022-08-22
#> 39: 2023-03-13
#> 40: 2023-05-24
#> 41: 2023-07-07
#> 42: 2024-03-05
#> 43: 2024-05-08
#> 44: 2024-07-27
#> 45: 2025-01-30
#> 46: 2025-08-13
#> 47: 2025-11-11
#>     date_added
#>         <char>
#>                                                                                           title
#>                                                                                          <char>
#>  1:                                                                 POLYMOD social contact data
#>  2:                                                                Social contact data for Peru
#>  3:                                                            Social contact data for Zimbabwe
#>  4:                                                              Social contact data for France
#>  5:                                                           Social contact data for Hong Kong
#>  6:                                                             Social contact data for Vietnam
#>  7:                                                                  Social contact data for UK
#>  8:                              Social contact data for Zambia and South Africa (CODA dataset)
#>  9:                                                      Social contact data for China mainland
#> 10:                                                              Social contact data for Russia
#> 11:                                                        CoMix social contact data (Belgium )
#> 12:                                                 Social contact data for Belgium (2010-2011)
#> 13:                                                      Social contact data for Belgium (2006)
#> 14:                                     Social contact data before and during COVID-19 in China
#> 15:                                                            Social contact data for Thailand
#> 16:                                                     Social contact data for Thailand (2015)
#> 17:                                                         CoMix social contact data (Austria)
#> 18:                                                     CoMix social contact data (Netherlands)
#> 19:                                                              CoMix social contact data (UK)
#> 20:                                                         CoMix social contact data (Denmark)
#> 21:                                                           CoMix social contact data (Spain)
#> 22:                                                          CoMix social contact data (France)
#> 23:                                                           CoMix social contact data (Italy)
#> 24:                                                        CoMix social contact data (Portugal)
#> 25:                                                          CoMix social contact data (Poland)
#> 26:                                                     Social contact data for the Netherlands
#> 27:                                                          CoMix social contact data (Greece)
#> 28:                                                        CoMix social contact data (Slovenia)
#> 29:                                           Social contact data for IDPs in Somaliland (2019)
#> 30:                                                              Social contact data for Taiwan
#> 31:                                                         CoMix social contact data (Croatia)
#> 32:                                                        CoMix social contact data (Slovakia)
#> 33:                                                         CoMix social contact data (Hungary)
#> 34:                                                         CoMix social contact data (Estonia)
#> 35:                                                       CoMix social contact data (Lithuania)
#> 36:                                                         CoMix social contact data (Finland)
#> 37:                                                     CoMix social contact data (Switzerland)
#> 38:                                                               CoMix 2.0 social contact data
#> 39:                               Contact data of older adults (70+) in the Netherlands in 2021
#> 40:                                                          Household contact survey (Belgium)
#> 41:                                       Contact data of Children in Belgium, Italy and Poland
#> 42:        Contact data of Pienter3 (2016-2017) and PiCo (2020-2023) studies in the Netherlands
#> 43:                                                CoMix data (last round in BE, CH, NL and UK)
#> 44:                           Social contact data for the BHDSS and FWHDSS in the Gambia (2022)
#> 45: Social mixing patterns of United States health care personnel at a quaternary health center
#> 46:                                                               Reconnect social contact data
#> 47:                                               MixIT: Post-pandemic social contacts in Italy
#>                                                                                           title
#>                                                                                          <char>
#>                   creator                                     url
#>                    <char>                                  <char>
#>  1:          Joël Mossong  https://doi.org/10.5281/zenodo.3874557
#>  2:    Carlos G. Grijalva  https://doi.org/10.5281/zenodo.3874805
#>  3:      Alessia Melegaro  https://doi.org/10.5281/zenodo.3886638
#>  4:      Guillaume Béraud  https://doi.org/10.5281/zenodo.3886590
#>  5:          Kathy  Leung  https://doi.org/10.5281/zenodo.3874808
#>  6:           Horby Peter  https://doi.org/10.5281/zenodo.3874802
#>  7:   Albert Jan van Hoek  https://doi.org/10.5281/zenodo.3874717
#>  8:         Peter J. Dodd  https://doi.org/10.5281/zenodo.3874675
#>  9:       Zhang, Juanjuan  https://doi.org/10.5281/zenodo.3878754
#> 10:       Maria Litvinova  https://doi.org/10.5281/zenodo.3874674
#> 11:        Pietro Coletti https://doi.org/10.5281/zenodo.10549953
#> 12:         Willem Lander  https://doi.org/10.5281/zenodo.4302055
#> 13:             Hens Niel  https://doi.org/10.5281/zenodo.4059864
#> 14:        Zhang Juanjuan  https://doi.org/10.5281/zenodo.7326686
#> 15:        Mahikul Wiriya  https://doi.org/10.5281/zenodo.4086739
#> 16:    Weerasak Putthasri  https://doi.org/10.5281/zenodo.4739777
#> 17:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362906
#> 18:       Backer, Jantien  https://doi.org/10.5281/zenodo.7276465
#> 19:            Gimma, Amy https://doi.org/10.5281/zenodo.13684044
#> 20:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362899
#> 21:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362898
#> 22:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362893
#> 23:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362888
#> 24:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362887
#> 25:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362879
#> 26: van de Kassteele, Jan  https://doi.org/10.5281/zenodo.5062244
#> 27:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362870
#> 28:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362865
#> 29:  van Zandvoort, Kevin  https://doi.org/10.5281/zenodo.7071876
#> 30:         Fu, Yang-Chih  https://doi.org/10.5281/zenodo.6385759
#> 31:            Gimma, Amy  https://doi.org/10.5281/zenodo.7257433
#> 32:            Gimma, Amy  https://doi.org/10.5281/zenodo.6535357
#> 33:            Gimma, Amy  https://doi.org/10.5281/zenodo.6535344
#> 34:            Gimma, Amy  https://doi.org/10.5281/zenodo.6535313
#> 35:            Gimma, Amy  https://doi.org/10.5281/zenodo.6542668
#> 36:            Gimma, Amy  https://doi.org/10.5281/zenodo.6542664
#> 37:            Gimma, Amy  https://doi.org/10.5281/zenodo.6542657
#> 38:       Coletti, Pietro  https://doi.org/10.5281/zenodo.7331926
#> 39:     Jantien A. Backer  https://doi.org/10.5281/zenodo.7751724
#> 40:      Goeyvaerts, Nele  https://doi.org/10.5281/zenodo.7965594
#> 41:        Coletti,Pietro  https://doi.org/10.5281/zenodo.8123632
#> 42:       Backer, Jantien https://doi.org/10.5281/zenodo.10370353
#> 43:   Jarvis, Christopher https://doi.org/10.5281/zenodo.11154066
#> 44:           Osei, Isaac https://doi.org/10.5281/zenodo.13101862
#> 45:       Pischel, Lauren https://doi.org/10.5281/zenodo.14156576
#> 46:      Goodfellow, Lucy https://doi.org/10.5281/zenodo.17339866
#> 47:     Lucchini, Lorenzo https://doi.org/10.5281/zenodo.17579537
#>                   creator                                     url
#>                    <char>                                  <char>
peru_survey <- download_survey("https://doi.org/10.5281/zenodo.1095664")
#> Warning: Directory differs from `contactsurveys_dir()`
#> ! Files may persist between R sessions.
#> ℹ See `contactsurveys_dir()` for more details.
#> Fetching contact survey filenames from: https://doi.org/10.5281/zenodo.1095664.
#> ✔ Successfully fetched list of published records!
#> ! No record for DOI '10.5281/zenodo.1095664'!
#> ℹ Try to get deposition by Zenodo specific record id '1095664'
#> ✔ Successfully fetched list of published records!
#> ! No record for id '1095664'!
#> ℹ Successfully fetched list of published records - page 1 (size = 10)
#> ✔ Successfully fetched list of published records!
#> ✔ Successfully fetched published record for concept DOI '10.5281/zenodo.1095664'!
#> Downloading from https://doi.org/10.5281/zenodo.1095664.
#> ! Overwrite is 'false', aborting download of existing files
#> ℹ Download in sequential mode
#> [zen4R][INFO] ZenodoRecord - Download in sequential mode 
#> ℹ Will download 7 files from record '3874805' (doi: '10.5281/zenodo.3874805') - total size: 760.6 KiB
#> [zen4R][INFO] ZenodoRecord - Will download 7 files from record '3874805' (doi: '10.5281/zenodo.3874805') - total size: 760.6 KiB 
#> ℹ Downloading file '2015_Grijalva_Peru_sday.csv' - size: 16 KiB
#> [zen4R][INFO] Downloading file '2015_Grijalva_Peru_sday.csv' - size: 16 KiB
#> ℹ Downloading file '2015_Grijalva_Peru_participant_common.csv' - size: 11.3 KiB
#> [zen4R][INFO] Downloading file '2015_Grijalva_Peru_participant_common.csv' - size: 11.3 KiB
#> ℹ Downloading file '2015_Grijalva_Peru_hh_extra.csv' - size: 27 KiB
#> [zen4R][INFO] Downloading file '2015_Grijalva_Peru_hh_extra.csv' - size: 27 KiB
#> ℹ Downloading file '2015_Grijalva_Peru_hh_common.csv' - size: 1.5 KiB
#> [zen4R][INFO] Downloading file '2015_Grijalva_Peru_hh_common.csv' - size: 1.5 KiB
#> ℹ Downloading file '2015_Grijalva_Peru_dictionary.xls' - size: 32.5 KiB
#> [zen4R][INFO] Downloading file '2015_Grijalva_Peru_dictionary.xls' - size: 32.5 KiB
#> ℹ Downloading file '2015_Grijalva_Peru_contact_common.csv' - size: 617.3 KiB
#> [zen4R][INFO] Downloading file '2015_Grijalva_Peru_contact_common.csv' - size: 617.3 KiB
#> ℹ Downloading file '2015_Grijalva_Peru_participant_extra.csv' - size: 55 KiB
#> [zen4R][INFO] Downloading file '2015_Grijalva_Peru_participant_extra.csv' - size: 55 KiB
#> ℹ Files downloaded at '/tmp/RtmpDoWpi2/zenodo.1095664'.
#> [zen4R][INFO] Files downloaded at '/tmp/RtmpDoWpi2/zenodo.1095664'.
#> ℹ Verifying file integrity...
#> [zen4R][INFO] ZenodoRecord - Verifying file integrity... 
#> ℹ File '2015_Grijalva_Peru_sday.csv': integrity verified (md5sum: b43c28fa6cce8d7bd6ec6b0621aa5b02)
#> [zen4R][INFO] File '2015_Grijalva_Peru_sday.csv': integrity verified (md5sum: b43c28fa6cce8d7bd6ec6b0621aa5b02)
#> ℹ File '2015_Grijalva_Peru_participant_common.csv': integrity verified (md5sum: dada729474938c5ed593fc824f98fff9)
#> [zen4R][INFO] File '2015_Grijalva_Peru_participant_common.csv': integrity verified (md5sum: dada729474938c5ed593fc824f98fff9)
#> ℹ File '2015_Grijalva_Peru_hh_extra.csv': integrity verified (md5sum: ad68e9171a547a0634998f413c02464d)
#> [zen4R][INFO] File '2015_Grijalva_Peru_hh_extra.csv': integrity verified (md5sum: ad68e9171a547a0634998f413c02464d)
#> ℹ File '2015_Grijalva_Peru_hh_common.csv': integrity verified (md5sum: a86d50476a603f7633de8f30959b6b03)
#> [zen4R][INFO] File '2015_Grijalva_Peru_hh_common.csv': integrity verified (md5sum: a86d50476a603f7633de8f30959b6b03)
#> ℹ File '2015_Grijalva_Peru_dictionary.xls': integrity verified (md5sum: 4c43fb5e299090740663db093823fdd9)
#> [zen4R][INFO] File '2015_Grijalva_Peru_dictionary.xls': integrity verified (md5sum: 4c43fb5e299090740663db093823fdd9)
#> ℹ File '2015_Grijalva_Peru_contact_common.csv': integrity verified (md5sum: 50dcb17f306aa7c62846351c5019bdad)
#> [zen4R][INFO] File '2015_Grijalva_Peru_contact_common.csv': integrity verified (md5sum: 50dcb17f306aa7c62846351c5019bdad)
#> ℹ File '2015_Grijalva_Peru_participant_extra.csv': integrity verified (md5sum: 4d7044f954db6a83ee1b9bcc95b24cfa)
#> [zen4R][INFO] File '2015_Grijalva_Peru_participant_extra.csv': integrity verified (md5sum: 4d7044f954db6a83ee1b9bcc95b24cfa)
#> ✔ End of download
#> [zen4R][INFO] ZenodoRecord - End of download 
# }
```
