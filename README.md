
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

``` r
library(contactsurveys)
```

`contactsurveys` provides access to all surveys in the [Social contact
data](https://zenodo.org/communities/social_contact_data) community on
[Zenodo](https://zenodo.org).

## Listing surveys

The available surveys can be listed (if an internet connection is
available) with `list_surveys()`

``` r
social_contact_surveys <- list_surveys(verbose = FALSE)
dim(social_contact_surveys)
```

    ## [1] 34  4

``` r
head(social_contact_surveys)
```

    ## Key: <date_added>
    ##    date_added                                                          title
    ##        <char>                                                         <char>
    ## 1: 2017-11-07                                    POLYMOD social contact data
    ## 2: 2017-12-07                                   Social contact data for Peru
    ## 3: 2017-12-22                                   Zimbabwe social contact data
    ## 4: 2018-01-23                                     France social contact data
    ## 5: 2018-09-05                                     Social contact data for UK
    ## 6: 2019-01-24 Social contact data for Zambia and South Africa (CODA dataset)
    ##                creator                                    url
    ##                 <char>                                 <char>
    ## 1:        Joël Mossong https://doi.org/10.5281/zenodo.3874557
    ## 2:  Carlos G. Grijalva https://doi.org/10.5281/zenodo.3874805
    ## 3:    Alessia Melegaro https://doi.org/10.5281/zenodo.1251944
    ## 4:    Guillaume Béraud https://doi.org/10.5281/zenodo.1158452
    ## 5: Albert Jan van Hoek https://doi.org/10.5281/zenodo.3874717
    ## 6:       Peter J. Dodd https://doi.org/10.5281/zenodo.2548693

By default, the survey data from `list_surveys()` is effectively cached,
so it will run very quickly the next time you run it. See
`?list_surveys()` for more detail.

## Downloading surveys

Surveys can be downloaded using `download_survey()`. This will get the
relevant data of a survey given its Zenodo DOI (as returned by
`list_surveys()`).

``` r
polymod_doi <- "https://doi.org/10.5281/zenodo.3874557"
polymod_survey_files <- download_survey(polymod_doi, verbose = FALSE)
polymod_survey_files
```

    ## [1] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/zenodo.3874557/2008_Mossong_POLYMOD_contact_common.csv"    
    ## [2] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/zenodo.3874557/2008_Mossong_POLYMOD_dictionary.xls"        
    ## [3] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/zenodo.3874557/2008_Mossong_POLYMOD_hh_common.csv"         
    ## [4] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/zenodo.3874557/2008_Mossong_POLYMOD_hh_extra.csv"          
    ## [5] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/zenodo.3874557/2008_Mossong_POLYMOD_participant_common.csv"
    ## [6] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/zenodo.3874557/2008_Mossong_POLYMOD_participant_extra.csv" 
    ## [7] "/Users/runner/Library/Application Support/org.R-project.R/R/contactsurveys/zenodo.3874557/2008_Mossong_POLYMOD_sday.csv"

## Getting citations

A reference for any given survey can be obtained by passing a DOI to
`get_citation()`:

``` r
get_citation(polymod_doi, verbose = FALSE)
```

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
