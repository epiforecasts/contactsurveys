# Fetches a Zenodo record, marking a failed request as worth another attempt

`get_zenodo()` raises a plain error both when the request itself failed
— a refused connection, a reset, a gateway page that is not the JSON it
expects — and when the DOI matched no record, which no retry will
change. Only the wording tells them apart, so a change to it costs a
retry of a settled failure rather than a wrong answer.

## Usage

``` r
fetch_record(survey)
```

## Arguments

- survey:

  A DOI or URL, as passed to
  [`get_zenodo()`](https://rdrr.io/pkg/zen4R/man/get_zenodo.html).

## Value

The record, as
[`zen4R::get_zenodo()`](https://rdrr.io/pkg/zen4R/man/get_zenodo.html)
returns it

## Note

internal
