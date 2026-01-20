
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

    ## [1] 47  4

``` r
head(social_contact_surveys)
```

    ## Key: <date_added>
    ##    date_added                             title            creator
    ##        <char>                            <char>             <char>
    ## 1: 2017-11-07       POLYMOD social contact data       Joël Mossong
    ## 2: 2017-12-07      Social contact data for Peru Carlos G. Grijalva
    ## 3: 2017-12-22  Social contact data for Zimbabwe   Alessia Melegaro
    ## 4: 2018-01-23    Social contact data for France   Guillaume Béraud
    ## 5: 2018-02-05 Social contact data for Hong Kong       Kathy  Leung
    ## 6: 2018-06-14   Social contact data for Vietnam        Horby Peter
    ##                                       url
    ##                                    <char>
    ## 1: https://doi.org/10.5281/zenodo.3874557
    ## 2: https://doi.org/10.5281/zenodo.3874805
    ## 3: https://doi.org/10.5281/zenodo.3886638
    ## 4: https://doi.org/10.5281/zenodo.3886590
    ## 5: https://doi.org/10.5281/zenodo.3874808
    ## 6: https://doi.org/10.5281/zenodo.3874802

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
```

    ## Warning: The `age.limits` argument of `contact_matrix()` is deprecated as of socialmixr
    ## 1.0.0.
    ## ℹ Please use the `age_limits` argument instead.
    ## ℹ The deprecated feature was likely used in the socialmixr package.
    ##   Please report the issue at
    ##   <https://github.com/epiforecasts/socialmixr/issues>.
    ## This warning is displayed once per session.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
    ## generated.

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
