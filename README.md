
wayback : Tools to Work with the Various Internet Archive Wayback Machine APIs

The following functions are implemented:

-   `archive_available`: Does the Internet Archive have a URL cached?
-   `get_mementos`: Retrieve site mementos
-   `get_timemap`: Retrieve a timemap for a URL

### Installation

``` r
devtools::install_github("hrbrmstr/wayback")
```

### Usage

``` r
library(wayback)

# current verison
packageVersion("wayback")
```

    ## [1] '0.1.0'

``` r
archive_available("https://rud.is/b")
```

    ## # A tibble: 1 × 5
    ##                url available                                                 closet_url  timestamp status
    ##              <chr>     <lgl>                                                      <chr>     <dttm>  <chr>
    ## 1 https://rud.is/b      TRUE http://web.archive.org/web/20170105023512/http://rud.is/b/ 2017-01-05    200

``` r
get_mementos("https://rud.is/b")
```

    ## # A tibble: 6 × 3
    ##                                                         link           rel                  ts
    ##                                                        <chr>         <chr>              <dttm>
    ## 1                                           http://rud.is/b/      original                <NA>
    ## 2   http://web.archive.org/web/timemap/link/http://rud.is/b/       timemap                <NA>
    ## 3                http://web.archive.org/web/http://rud.is/b/      timegate                <NA>
    ## 4 http://web.archive.org/web/20170105023512/http://rud.is/b/  last memento 2017-01-05 02:35:12
    ## 5 http://web.archive.org/web/20110218004632/http://rud.is/b/ first memento 2011-02-18 00:46:32
    ## 6 http://web.archive.org/web/20170105023508/http://rud.is/b/  prev memento 2017-01-05 02:35:08

``` r
get_timemap("https://rud.is/b")
```

    ## # A tibble: 212 × 6
    ##              rel                                                       link                    type
    ##            <chr>                                                      <chr>                   <chr>
    ## 1       original                                           https://rud.is/b                    <NA>
    ## 2           self   http://web.archive.org/web/timemap/link/https://rud.is/b application/link-format
    ## 3       timegate                http://web.archive.org/web/https://rud.is/b                    <NA>
    ## 4  first memento http://web.archive.org/web/20110218004632/http://rud.is/b/                    <NA>
    ## 5        memento  http://web.archive.org/web/20110219065135/http://rud.is/b                    <NA>
    ## 6        memento http://web.archive.org/web/20110219065135/http://rud.is/b/                    <NA>
    ## 7        memento http://web.archive.org/web/20110220055412/http://rud.is/b/                    <NA>
    ## 8        memento http://web.archive.org/web/20110327171609/http://rud.is/b/                    <NA>
    ## 9        memento http://web.archive.org/web/20110412224903/http://rud.is/b/                    <NA>
    ## 10       memento  http://web.archive.org/web/20110426173807/http://rud.is/b                    <NA>
    ## # ... with 202 more rows, and 3 more variables: from <chr>, until <chr>, datetime <chr>

### Test Results

``` r
library(wayback)
library(testthat)

date()
```

    ## [1] "Sun Feb 26 18:24:29 2017"

``` r
test_dir("tests/")
```

    ## testthat results ========================================================================================================
    ## OK: 0 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================
