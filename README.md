
`wayback` : Tools to Work with the Various Internet Archive Wayback Machine APIs

[![Travis-CI Build Status](https://travis-ci.org/jonocarroll/wayback.svg?branch=dev-cdx)](https://travis-ci.org/jonocarroll/wayback) [![Coverage Status](https://img.shields.io/codecov/c/github/jonocarroll/wayback/dev-cdx.svg)](https://codecov.io/github/jonocarroll/wayback?branch=dev-cdx) <!-- [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/NA/NA?branch=master&svg=true)](https://ci.appveyor.com/project/NA/NA) -->

The following functions are implemented:

-   `archive_available`: Does the Internet Archive have a URL cached?
-   `cdx_basic_query`: Perform a basic/limited Internet Archive CDX resource query for a URL
-   `get_mementos`: Retrieve site mementos from the Internet Archive
-   `get_timemap`: Retrieve a timemap for a URL
<<<<<<< HEAD
-   `read_memento`: Read a resource directly from the Time Travel MementoWeb
=======
>>>>>>> 6524c336dc2cee192c01ec6f003f509bcba92681
-   `is_memento`: Various memento-type testers (useful in `purrr` or `dplyr` contexts)
-   `is_first_memento`: Various memento-type testers (useful in `purrr` or `dplyr` contexts)
-   `is_next_memento`: Various memento-type testers (useful in `purrr` or `dplyr` contexts)
-   `is_prev_memento`: Various memento-type testers (useful in `purrr` or `dplyr` contexts)
-   `is_last_memento`: Various memento-type testers (useful in `purrr` or `dplyr` contexts)
-   `is_original`: Various memento-type testers (useful in `purrr` or `dplyr` contexts)
-   `is_timemap`: Various memento-type testers (useful in `purrr` or `dplyr` contexts)
<<<<<<< HEAD
-   `is_timegate`: Various memento-type testers (useful in `purrr` or `dplyr` contexts)
=======
-   `is_timegate: Various memento-type testers (useful in`purrr`or`dplyr\` contexts)
>>>>>>> 6524c336dc2cee192c01ec6f003f509bcba92681

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

    ## [1] '0.3.0'

``` r
archive_available("https://yahoo.com/")
```

    ## # A tibble: 1 x 5
    ##                  url available                                                       closet_url  timestamp status
    ##                <chr>     <lgl>                                                            <chr>     <dttm>  <chr>
    ## 1 https://yahoo.com/      TRUE http://web.archive.org/web/20170830201359/https://www.yahoo.com/ 2017-08-30    200

``` r
get_mementos("https://yahoo.com/")
```

    ## # A tibble: 7 x 3
    ##                                                                  link           rel                  ts
    ##                                                                 <chr>         <chr>              <dttm>
    ## 1                                              https://www.yahoo.com/      original                  NA
    ## 2      http://web.archive.org/web/timemap/link/https://www.yahoo.com/       timemap                  NA
    ## 3                   http://web.archive.org/web/https://www.yahoo.com/      timegate                  NA
    ## 4 http://web.archive.org/web/19961017235908/http://www2.yahoo.com:80/ first memento 1996-10-17 23:59:08
    ## 5    http://web.archive.org/web/20170829194812/https://www.yahoo.com/  prev memento 2017-08-29 19:48:12
    ## 6    http://web.archive.org/web/20170830201359/https://www.yahoo.com/       memento 2017-08-30 20:13:59
    ## 7 http://web.archive.org/web/19961017235908/http://www2.yahoo.com:80/  last memento 1996-10-17 23:59:08

This one takes too long to regen every time

``` r
get_timemap("https://yahoo.com/")
```

``` r
cdx_basic_query("https://yahoo.com/", limit = 10) %>% 
  glimpse()
```

    ## Observations: 10
    ## Variables: 7
    ## $ urlkey     <chr> "com,yahoo)/", "com,yahoo)/", "com,yahoo)/", "com,yahoo)/", "com,yahoo)/", "com,yahoo)/", "com,y...
    ## $ timestamp  <dttm> 1996-10-17, 1996-10-17, 1996-10-17, 1996-10-17, 1996-10-17, 1996-10-17, 1996-10-20, 1996-10-22,...
    ## $ original   <chr> "http://www2.yahoo.com:80/", "http://www2.yahoo.com:80/", "http://www2.yahoo.com:80/", "http://w...
    ## $ mimetype   <chr> "text/html", "text/html", "text/html", "text/html", "text/html", "text/html", "text/html", "text...
<<<<<<< HEAD
    ## $ statuscode <chr> "200", "200", "200", "200", "200", "200", "200", "200", "200", "200"
    ## $ digest     <chr> "LOB7746BGHENCUWDONHQM7NPHUSNKZRN", "LOB7746BGHENCUWDONHQM7NPHUSNKZRN", "LOB7746BGHENCUWDONHQM7N...
    ## $ length     <dbl> 1811, 1811, 1811, 1811, 1811, 1811, 1888, 1954, 1950, 1939
=======
    ## $ statuscode <chr> "200", "301", "200", "200", "200", "200", "301", "200", "200", "301", "200", "301", "200", "301"...
    ## $ digest     <chr> "2DV4A2RNGAQ3CDMNASYIMMJM4TDPOPJC", "5464F3DRRISJGE3E5AJETQETHU6QZRUC", "EHJCAIH4ODA2QONHAHZNIRS...
    ## $ length     <dbl> 19156, 297, 18595, 19621, 27927, 26159, 298, 25823, 14959, 298, 15237, 297, 15180, 296, 15392, 2...

### Test Results

``` r
library(wayback)
library(testthat)

date()
```

    ## [1] "Tue Feb 28 17:57:33 2017"
>>>>>>> 6524c336dc2cee192c01ec6f003f509bcba92681

``` r
res <- read_memento("https://yahoo.com/")
res <- stringi::stri_split_lines(res)[[1]]
res <- c(head(res, 6), tail(res, 8))
cat(paste0(res, collaspe="\n"))
```

<<<<<<< HEAD
    ## <!DOCTYPE html>
    ##  <html id="atomic" lang="en-US" class="atomic my3columns  l-out Pos-r https fp fp-v2 rc1 fp-default mini-uh-on viewer-right ltr desktop Desktop bktUDC001,FP040,SR016,332">
    ##  <head>
    ##  
    ##  <!-- Start Wayback Rewrite JS Include -->
    ##  <!-- wbgrp-svc082.us.archive.org -->
    ##       FILE ARCHIVED ON 22:49:17 Dec 31, 2016 AND RETRIEVED FROM THE
    ##       INTERNET ARCHIVE ON 20:55:15 Aug 30, 2017.
    ##       JAVASCRIPT APPENDED BY WAYBACK MACHINE, COPYRIGHT INTERNET ARCHIVE.
    ##  
    ##       ALL OTHER CONTENT MAY ALSO BE PROTECTED BY COPYRIGHT (17 U.S.C.
    ##       SECTION 108(a)(3)).
    ##  -->
    ##
=======
    ## testthat results ========================================================================================================
    ## OK: 47 SKIPPED: 0 FAILED: 0
    ## 
    ## DONE ===================================================================================================================
    ## Keep up the good work.
>>>>>>> 6524c336dc2cee192c01ec6f003f509bcba92681
