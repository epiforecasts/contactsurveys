# Get citation from a DOI

This is a wrapper around
[`zen4R::get_citation()`](https://rdrr.io/pkg/zen4R/man/get_citation.html)
with a couple of smaller changes. Firstly, it silences output from
[`zen4R::get_citation()`](https://rdrr.io/pkg/zen4R/man/get_citation.html),
secondly the default citation style is "apa".

## Usage

``` r
get_citation(
  doi,
  style = c("bibtex", "apa", "harvard-cite-them-right", "modern-language-association",
    "vancouver", "chicago-fullnote-bibliography", "ieee"),
  verbose = TRUE
)
```

## Arguments

- doi:

  A string, the Zenodo DOI or concept DOI.

- style:

  A string, the citation style. Default is "bibtex". Possible values
  are: "bibtex", "harvard-cite-them-right", "apa",
  "modern-language-association", "vancouver",
  "chicago-fullnote-bibliography", or "ieee".

- verbose:

  logical. Should messages during citation fetching print to the screen?
  Default is TRUE.

## Value

A character string containing the citation in the requested style. For
`"bibtex"` style, returns an object of class `"csbib"`.

## Examples

``` r
# \donttest{
polymod_doi <- "https://doi.org/10.5281/zenodo.3874557"
get_citation(polymod_doi)
#> ℹ Fetching citation
#> ✔ Citation fetched! [842ms]
#> 
#> @dataset{joel_mossong_2020_3874557,
#>   author       = {Joël Mossong and
#>                   Niel Hens and
#>                   Mark Jit and
#>                   Philippe Beutels and
#>                   Kari Auranen and
#>                   Rafael Mikolajczyk and
#>                   Marco Massari and
#>                   Stefania Salmaso and
#>                   Gianpaolo Scalia Tomba and
#>                   Jacco Wallinga and
#>                   Janneke Heijne and
#>                   Malgorzata Sadkowska-Todys and
#>                   Magdalena Rosinska and
#>                   W. John Edmunds},
#>   title        = {POLYMOD social contact data},
#>   month        = jun,
#>   year         = 2020,
#>   publisher    = {Zenodo},
#>   version      = 2,
#>   doi          = {10.5281/zenodo.3874557},
#>   url          = {https://doi.org/10.5281/zenodo.3874557},
#> }
# }
```
