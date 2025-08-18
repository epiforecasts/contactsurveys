
# contactsurveys

<!-- badges: start -->

[![R-CMD-check](https://github.com/epiforecasts/contactsurveys/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/epiforecasts/contactsurveys/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/epiforecasts/contactsurveys/graph/badge.svg)](https://app.codecov.io/gh/epiforecasts/contactsurveys)
<!-- badges: end -->

`contactsurveys` is an `R` package to download contact survey data,
which can be used to derive social mixing matrices (see, for example,
the [socialmixr](https://github.com/epiforecasts/socialmixr) package).
This code was initially in the socialmixr package, but the code for
downloading surveys has been moved into this package.

# Installation

The development version can be installed using `remotes`

``` r
remotes::install_github("epiforecasts/contactsurveys")
```

# Example usage

`contactsurveys` provides access to all surveys in the [Social contact
data](https://zenodo.org/communities/social_contact_data) community on
[Zenodo](https://zenodo.org).

## Listing surveys

The available surveys can be listed (if an internet connection is
available) with `list_surveys()`

``` r
list_surveys()
```

    ## ℹ Downloading survey list from zenodo

    ## ✔ Downloading survey list from zenodo [17.8s]

    ## 

    ## Key: <date_added>
    ##     date_added
    ##         <char>
    ##  1: 2017-11-07
    ##  2: 2017-12-07
    ##  3: 2017-12-22
    ##  4: 2018-01-23
    ##  5: 2018-02-05
    ##  6: 2018-06-14
    ##  7: 2018-09-05
    ##  8: 2019-01-24
    ##  9: 2019-08-13
    ## 10: 2019-09-16
    ## 11: 2020-08-06
    ## 12: 2020-09-30
    ## 13: 2020-09-30
    ## 14: 2020-10-12
    ## 15: 2020-10-16
    ## 16: 2021-05-06
    ## 17: 2021-05-20
    ## 18: 2021-05-25
    ## 19: 2021-06-07
    ## 20: 2021-06-29
    ## 21: 2021-06-29
    ## 22: 2021-06-29
    ## 23: 2021-06-29
    ## 24: 2021-06-29
    ## 25: 2021-06-29
    ## 26: 2021-07-03
    ## 27: 2021-07-26
    ## 28: 2021-07-26
    ## 29: 2021-08-20
    ## 30: 2022-04-11
    ## 31: 2022-05-10
    ## 32: 2022-05-10
    ## 33: 2022-05-10
    ## 34: 2022-05-10
    ## 35: 2022-05-12
    ## 36: 2022-05-12
    ## 37: 2022-05-12
    ## 38: 2022-08-22
    ## 39: 2023-03-13
    ## 40: 2023-05-24
    ## 41: 2023-07-07
    ## 42: 2024-03-05
    ## 43: 2024-05-08
    ## 44: 2024-07-27
    ## 45: 2025-01-30
    ##     date_added
    ##                                                                                           title
    ##                                                                                          <char>
    ##  1:                                                                 POLYMOD social contact data
    ##  2:                                                                Social contact data for Peru
    ##  3:                                                            Social contact data for Zimbabwe
    ##  4:                                                              Social contact data for France
    ##  5:                                                           Social contact data for Hong Kong
    ##  6:                                                             Social contact data for Vietnam
    ##  7:                                                                  Social contact data for UK
    ##  8:                              Social contact data for Zambia and South Africa (CODA dataset)
    ##  9:                                                      Social contact data for China mainland
    ## 10:                                                              Social contact data for Russia
    ## 11:                                                        CoMix social contact data (Belgium )
    ## 12:                                                 Social contact data for Belgium (2010-2011)
    ## 13:                                                      Social contact data for Belgium (2006)
    ## 14:                                     Social contact data before and during COVID-19 in China
    ## 15:                                                            Social contact data for Thailand
    ## 16:                                                     Social contact data for Thailand (2015)
    ## 17:                                                         CoMix social contact data (Austria)
    ## 18:                                                     CoMix social contact data (Netherlands)
    ## 19:                                                              CoMix social contact data (UK)
    ## 20:                                                         CoMix social contact data (Denmark)
    ## 21:                                                           CoMix social contact data (Spain)
    ## 22:                                                          CoMix social contact data (France)
    ## 23:                                                           CoMix social contact data (Italy)
    ## 24:                                                        CoMix social contact data (Portugal)
    ## 25:                                                          CoMix social contact data (Poland)
    ## 26:                                                     Social contact data for the Netherlands
    ## 27:                                                          CoMix social contact data (Greece)
    ## 28:                                                        CoMix social contact data (Slovenia)
    ## 29:                                           Social contact data for IDPs in Somaliland (2019)
    ## 30:                                                              Social contact data for Taiwan
    ## 31:                                                         CoMix social contact data (Croatia)
    ## 32:                                                        CoMix social contact data (Slovakia)
    ## 33:                                                         CoMix social contact data (Hungary)
    ## 34:                                                         CoMix social contact data (Estonia)
    ## 35:                                                       CoMix social contact data (Lithuania)
    ## 36:                                                         CoMix social contact data (Finland)
    ## 37:                                                     CoMix social contact data (Switzerland)
    ## 38:                                                               CoMix 2.0 social contact data
    ## 39:                               Contact data of older adults (70+) in the Netherlands in 2021
    ## 40:                                                          Household contact survey (Belgium)
    ## 41:                                       Contact data of Children in Belgium, Italy and Poland
    ## 42:        Contact data of Pienter3 (2016-2017) and PiCo (2020-2023) studies in the Netherlands
    ## 43:                                                CoMix data (last round in BE, CH, NL and UK)
    ## 44:                           Social contact data for the BHDSS and FWHDSS in the Gambia (2022)
    ## 45: Social mixing patterns of United States health care personnel at a quaternary health center
    ##                                                                                           title
    ##                   creator                                     url
    ##                    <char>                                  <char>
    ##  1:          Joël Mossong  https://doi.org/10.5281/zenodo.3874557
    ##  2:    Carlos G. Grijalva  https://doi.org/10.5281/zenodo.3874805
    ##  3:      Alessia Melegaro  https://doi.org/10.5281/zenodo.3886638
    ##  4:      Guillaume Béraud  https://doi.org/10.5281/zenodo.3886590
    ##  5:          Kathy  Leung  https://doi.org/10.5281/zenodo.3874808
    ##  6:           Horby Peter  https://doi.org/10.5281/zenodo.3874802
    ##  7:   Albert Jan van Hoek  https://doi.org/10.5281/zenodo.3874717
    ##  8:         Peter J. Dodd  https://doi.org/10.5281/zenodo.3874675
    ##  9:       Zhang, Juanjuan  https://doi.org/10.5281/zenodo.3878754
    ## 10:       Maria Litvinova  https://doi.org/10.5281/zenodo.3874674
    ## 11:        Pietro Coletti https://doi.org/10.5281/zenodo.10549953
    ## 12:         Willem Lander  https://doi.org/10.5281/zenodo.4302055
    ## 13:             Hens Niel  https://doi.org/10.5281/zenodo.4059864
    ## 14:        Zhang Juanjuan  https://doi.org/10.5281/zenodo.7326686
    ## 15:        Mahikul Wiriya  https://doi.org/10.5281/zenodo.4086739
    ## 16:    Weerasak Putthasri  https://doi.org/10.5281/zenodo.4739777
    ## 17:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362906
    ## 18:       Backer, Jantien  https://doi.org/10.5281/zenodo.7276465
    ## 19:            Gimma, Amy https://doi.org/10.5281/zenodo.13684044
    ## 20:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362899
    ## 21:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362898
    ## 22:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362893
    ## 23:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362888
    ## 24:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362887
    ## 25:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362879
    ## 26: van de Kassteele, Jan  https://doi.org/10.5281/zenodo.5062244
    ## 27:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362870
    ## 28:            Gimma, Amy  https://doi.org/10.5281/zenodo.6362865
    ## 29:  van Zandvoort, Kevin  https://doi.org/10.5281/zenodo.7071876
    ## 30:         Fu, Yang-Chih  https://doi.org/10.5281/zenodo.6385759
    ## 31:            Gimma, Amy  https://doi.org/10.5281/zenodo.7257433
    ## 32:            Gimma, Amy  https://doi.org/10.5281/zenodo.6535357
    ## 33:            Gimma, Amy  https://doi.org/10.5281/zenodo.6535344
    ## 34:            Gimma, Amy  https://doi.org/10.5281/zenodo.6535313
    ## 35:            Gimma, Amy  https://doi.org/10.5281/zenodo.6542668
    ## 36:            Gimma, Amy  https://doi.org/10.5281/zenodo.6542664
    ## 37:            Gimma, Amy  https://doi.org/10.5281/zenodo.6542657
    ## 38:       Coletti, Pietro  https://doi.org/10.5281/zenodo.7331926
    ## 39:     Jantien A. Backer  https://doi.org/10.5281/zenodo.7751724
    ## 40:      Goeyvaerts, Nele  https://doi.org/10.5281/zenodo.7965594
    ## 41:        Coletti,Pietro  https://doi.org/10.5281/zenodo.8123632
    ## 42:       Backer, Jantien https://doi.org/10.5281/zenodo.10370353
    ## 43:   Jarvis, Christopher https://doi.org/10.5281/zenodo.11154066
    ## 44:           Osei, Isaac https://doi.org/10.5281/zenodo.13101862
    ## 45:       Pischel, Lauren https://doi.org/10.5281/zenodo.14156576
    ##                   creator                                     url

By default, the survey data from `list_surveys()` is effectively cached,
so it will run very quickly the next time you run it. See
`?list_surveys()` for more detail.

## Downloading surveys

Surveys can be downloaded using `download_survey()`. This will get the
relevant data of a survey given its Zenodo DOI (as returned by
`list_surveys()`).

``` r
polymod_doi <- "https://doi.org/10.5281/zenodo.3874557"
polymod_survey_files <- download_survey(polymod_doi)
```

    ## Fetching contact survey filenames from: https://doi.org/10.5281/zenodo.3874557.
    ## ℹ Successfully fetched list of published records - page 1
    ## 
    ## ✔ Successfully fetched list of published records!
    ## 
    ## ✔ Successfully fetched record for DOI '10.5281/zenodo.3874557'!
    ## 
    ## Downloading from https://doi.org/10.5281/zenodo.3874557.
    ## ! Overwrite is 'false', aborting download of existing files
    ## 
    ## ℹ Download in sequential mode

    ## [zen4R][INFO] ZenodoRecord - Download in sequential mode

    ## ℹ Will download 7 files from record '3874557' (doi: '10.5281/zenodo.3874557') - total size: 7.4 MiB

    ## [zen4R][INFO] ZenodoRecord - Will download 7 files from record '3874557' (doi: '10.5281/zenodo.3874557') - total size: 7.4 MiB

    ## ℹ Downloading file '2008_Mossong_POLYMOD_hh_common.csv' - size: 120 KiB

    ## [zen4R][INFO] Downloading file '2008_Mossong_POLYMOD_hh_common.csv' - size: 120 KiB

    ## ℹ Downloading file '2008_Mossong_POLYMOD_contact_common.csv' - size: 6.2 MiB

    ## [zen4R][INFO] Downloading file '2008_Mossong_POLYMOD_contact_common.csv' - size: 6.2 MiB

    ## ℹ Downloading file '2008_Mossong_POLYMOD_dictionary.xls' - size: 41 KiB

    ## [zen4R][INFO] Downloading file '2008_Mossong_POLYMOD_dictionary.xls' - size: 41 KiB

    ## ℹ Downloading file '2008_Mossong_POLYMOD_hh_extra.csv' - size: 523 KiB

    ## [zen4R][INFO] Downloading file '2008_Mossong_POLYMOD_hh_extra.csv' - size: 523 KiB

    ## ℹ Downloading file '2008_Mossong_POLYMOD_participant_common.csv' - size: 153.1 KiB

    ## [zen4R][INFO] Downloading file '2008_Mossong_POLYMOD_participant_common.csv' - size: 153.1 KiB

    ## ℹ Downloading file '2008_Mossong_POLYMOD_participant_extra.csv' - size: 221.8 KiB

    ## [zen4R][INFO] Downloading file '2008_Mossong_POLYMOD_participant_extra.csv' - size: 221.8 KiB

    ## ℹ Downloading file '2008_Mossong_POLYMOD_sday.csv' - size: 188.7 KiB

    ## [zen4R][INFO] Downloading file '2008_Mossong_POLYMOD_sday.csv' - size: 188.7 KiB

    ## ℹ Files downloaded at '/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys'.

    ## [zen4R][INFO] Files downloaded at '/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys'.

    ## ℹ Verifying file integrity...

    ## [zen4R][INFO] ZenodoRecord - Verifying file integrity...

    ## ℹ File '2008_Mossong_POLYMOD_hh_common.csv': integrity verified (md5sum: d7fb1359ad84dba8cce4c444063940aa)

    ## [zen4R][INFO] File '2008_Mossong_POLYMOD_hh_common.csv': integrity verified (md5sum: d7fb1359ad84dba8cce4c444063940aa)

    ## ℹ File '2008_Mossong_POLYMOD_contact_common.csv': integrity verified (md5sum: 52baf32033bf780786fae6604043ec00)

    ## [zen4R][INFO] File '2008_Mossong_POLYMOD_contact_common.csv': integrity verified (md5sum: 52baf32033bf780786fae6604043ec00)

    ## ℹ File '2008_Mossong_POLYMOD_dictionary.xls': integrity verified (md5sum: 06415516c91b52dedfaa53622e352647)

    ## [zen4R][INFO] File '2008_Mossong_POLYMOD_dictionary.xls': integrity verified (md5sum: 06415516c91b52dedfaa53622e352647)

    ## ℹ File '2008_Mossong_POLYMOD_hh_extra.csv': integrity verified (md5sum: b0063f8d1a4f391d919495493611b3f1)

    ## [zen4R][INFO] File '2008_Mossong_POLYMOD_hh_extra.csv': integrity verified (md5sum: b0063f8d1a4f391d919495493611b3f1)

    ## ℹ File '2008_Mossong_POLYMOD_participant_common.csv': integrity verified (md5sum: ac784c281a71e15c7e64eaf2d6365709)

    ## [zen4R][INFO] File '2008_Mossong_POLYMOD_participant_common.csv': integrity verified (md5sum: ac784c281a71e15c7e64eaf2d6365709)

    ## ℹ File '2008_Mossong_POLYMOD_participant_extra.csv': integrity verified (md5sum: 4e2dd8d6ba2d23bb5b1f236be215b936)

    ## [zen4R][INFO] File '2008_Mossong_POLYMOD_participant_extra.csv': integrity verified (md5sum: 4e2dd8d6ba2d23bb5b1f236be215b936)

    ## ℹ File '2008_Mossong_POLYMOD_sday.csv': integrity verified (md5sum: 148c5fc86ca10d385e3d047014e14a09)

    ## [zen4R][INFO] File '2008_Mossong_POLYMOD_sday.csv': integrity verified (md5sum: 148c5fc86ca10d385e3d047014e14a09)

    ## ✔ End of download

    ## [zen4R][INFO] ZenodoRecord - End of download

``` r
polymod_survey_files
```

    ## [1] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/2008_Mossong_POLYMOD_hh_common.csv"         
    ## [2] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/2008_Mossong_POLYMOD_contact_common.csv"    
    ## [3] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/2008_Mossong_POLYMOD_dictionary.xls"        
    ## [4] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/2008_Mossong_POLYMOD_hh_extra.csv"          
    ## [5] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/2008_Mossong_POLYMOD_participant_common.csv"
    ## [6] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/2008_Mossong_POLYMOD_participant_extra.csv" 
    ## [7] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/2008_Mossong_POLYMOD_sday.csv"

## Getting citations

A reference for any given survey can be obtained by passing a DOI to
`get_citation()`:

``` r
get_citation(polymod_doi)
```

    ## ℹ Fetching citation

    ## ✔ Citation fetched! [965ms]

    ## 

    ## @dataset{joel_mossong_2020_3874557,
    ##   author       = {Joël Mossong and
    ##                   Niel Hens and
    ##                   Mark Jit and
    ##                   Philippe Beutels and
    ##                   Kari Auranen and
    ##                   Rafael Mikolajczyk and
    ##                   Marco Massari and
    ##                   Stefania Salmaso and
    ##                   Gianpaolo Scalia Tomba and
    ##                   Jacco Wallinga and
    ##                   Janneke Heijne and
    ##                   Malgorzata Sadkowska-Todys and
    ##                   Magdalena Rosinska and
    ##                   W. John Edmunds},
    ##   title        = {POLYMOD social contact data},
    ##   month        = jun,
    ##   year         = 2020,
    ##   publisher    = {Zenodo},
    ##   version      = 2,
    ##   doi          = {10.5281/zenodo.3874557},
    ##   url          = {https://doi.org/10.5281/zenodo.3874557},
    ## }

## Using contact matrices with socialmixr

You can then use the survey files downloaded with functions from
[socialmixr](https://github.com/epiforecasts/socialmixr),
`load_survey()` and `contact_matrix()`.

``` r
library(socialmixr)
```

    ## 
    ## Attaching package: 'socialmixr'

    ## The following objects are masked from 'package:contactsurveys':
    ## 
    ##     download_survey, get_citation, list_surveys

``` r
polymod_loaded <- load_survey(polymod_survey_files)
```

    ## Warning: No reference provided.

``` r
uk_contact_matrix <- contact_matrix(
      polymod_loaded,
      countries = "United Kingdom",
      age.limits = c(0, 18, 65)
    )
```

    ## Removing participants that have contacts without age information.
    ## ℹ To change this behaviour, set the 'missing.contact.age' option.

``` r
uk_contact_matrix
```

    ## $matrix
    ##          contact.age.group
    ## age.group   [0,18)  [18,65)       65+
    ##   [0,18)  7.813187 5.505495 0.2664835
    ##   [18,65) 2.103215 8.174281 0.6463621
    ##   65+     1.160714 5.464286 1.7142857
    ## 
    ## $participants
    ##    age.group participants proportion
    ##       <char>        <int>      <num>
    ## 1:    [0,18)          364  0.3600396
    ## 2:   [18,65)          591  0.5845697
    ## 3:       65+           56  0.0553907

## Contributors

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->

All contributions to this project are gratefully acknowledged using the
[`allcontributors` package](https://github.com/ropensci/allcontributors)
following the [allcontributors](https://allcontributors.org)
specification. Contributions of any kind are welcome!

### Code

<a href="https://github.com/epiforecasts/contactsurveys/commits?author=sbfnk">sbfnk</a>,
<a href="https://github.com/epiforecasts/contactsurveys/commits?author=Bisaloo">Bisaloo</a>,
<a href="https://github.com/epiforecasts/contactsurveys/commits?author=njtierney">njtierney</a>,
<a href="https://github.com/epiforecasts/contactsurveys/commits?author=lwillem">lwillem</a>,
<a href="https://github.com/epiforecasts/contactsurveys/commits?author=Degoot-AM">Degoot-AM</a>,
<a href="https://github.com/epiforecasts/contactsurveys/commits?author=jarvisc1">jarvisc1</a>,
<a href="https://github.com/epiforecasts/contactsurveys/commits?author=alxsrobert">alxsrobert</a>

### Issues

<a href="https://github.com/epiforecasts/contactsurveys/issues?q=is%3Aissue+author%3Aavallecam">avallecam</a>

<!-- markdownlint-enable -->
<!-- prettier-ignore-end -->
<!-- ALL-CONTRIBUTORS-LIST:END -->
