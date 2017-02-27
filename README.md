
wayback : Tools to Work with the Various Internet Archive Wayback Machine APIs

[![Travis-CI Build Status](https://travis-ci.org/jonocarroll/wayback.svg?branch=dev-cdx)](https://travis-ci.org/jonocarroll/wayback) [![Coverage Status](https://img.shields.io/codecov/c/github/jonocarroll/wayback/dev-cdx.svg)](https://codecov.io/github/jonocarroll/wayback?branch=dev-cdx)

The following functions are implemented:

-   `archive_available`: Does the Internet Archive have a URL cached?
-   `cdx_basic_query`: Perform a basic/limited Internet Archive CDX resource query for a URL
-   `get_mementos`: Retrieve site mementos
-   `get_timemap`: Retrieve a timemap for a URL

### Installation

``` r
devtools::install_github("hrbrmstr/wayback")
```

### Usage

``` r
library(wayback)
library(tidyverse)

# current verison
packageVersion("wayback")
```

    ## [1] '0.2.0'

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

``` r
cdx_basic_query("https://rud.is/b") %>% 
  glimpse()
```

    ## Observations: 211
    ## Variables: 7
    ## $ urlkey     <chr> "is,rud)/b", "is,rud)/b", "is,rud)/b", "is,rud)/b", "is,rud)/b", "is,rud)/b", "is,rud)/b", "is,r...
    ## $ timestamp  <dttm> 2011-02-18, 2011-02-19, 2011-02-19, 2011-02-20, 2011-03-27, 2011-04-12, 2011-04-26, 2011-04-26,...
    ## $ original   <chr> "http://rud.is:80/b/", "http://rud.is:80/b", "http://rud.is:80/b/", "http://rud.is/b/", "http://...
    ## $ mimetype   <chr> "text/html", "text/html", "text/html", "text/html", "text/html", "text/html", "text/html", "text...
    ## $ statuscode <chr> "200", "301", "200", "200", "200", "200", "301", "200", "200", "301", "200", "301", "200", "301"...
    ## $ digest     <chr> "2DV4A2RNGAQ3CDMNASYIMMJM4TDPOPJC", "5464F3DRRISJGE3E5AJETQETHU6QZRUC", "EHJCAIH4ODA2QONHAHZNIRS...
    ## $ length     <dbl> 19156, 297, 18595, 19621, 27927, 26159, 298, 25823, 14959, 298, 15237, 297, 15180, 296, 15392, 2...

### Test Results

``` r
library(wayback)
library(testthat)

date()
```

    ## [1] "Tue Feb 28 00:02:48 2017"

``` r
test_dir("tests/")
```

    ## testthat results ========================================================================================================
    ## OK: 39 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================
