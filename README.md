
[![Travis-CI Build
Status](https://travis-ci.org/hrbrmstr/wayback.svg?branch=master)](https://travis-ci.org/hrbrmstr/wayback)
[![codecov](https://codecov.io/gh/hrbrmstr/wayback/branch/master/graph/badge.svg)](https://codecov.io/gh/hrbrmstr/wayback)
[![Appveyor
Status](https://ci.appveyor.com/api/projects/status/w9rwdf8a16t0amht/branch/master?svg=true)](https://ci.appveyor.com/project/hrbrmstr/wayback/branch/master)

# wayback

Tools to Work with Internet Archive Wayback Machine APIs

## Description

The ‘Internet Archive’ provides access to millions of cached sites.
Methods are provided to access these cached resources through the ‘APIs’
provided by the ‘Internet Archive’ and also content from ‘MementoWeb’.

## What’s Inside the Tin?

The following functions are implemented:

**Memento-ish API**:

  - `archive_available`: Does the Internet Archive have a URL cached?
  - `cdx_basic_query`: Perform a basic/limited Internet Archive CDX
    resource query for a URL
  - `get_mementos`: Retrieve site mementos from the Internet Archive
  - `get_timemap`: Retrieve a timemap for a URL
  - `read_memento`: Read a resource directly from the Time Travel
    MementoWeb
  - `is_memento`: Various memento-type testers (useful in `purrr` or
    `dplyr` contexts)
  - `is_first_memento`: Various memento-type testers (useful in `purrr`
    or `dplyr` contexts)
  - `is_next_memento`: Various memento-type testers (useful in `purrr`
    or `dplyr` contexts)
  - `is_prev_memento`: Various memento-type testers (useful in `purrr`
    or `dplyr` contexts)
  - `is_last_memento`: Various memento-type testers (useful in `purrr`
    or `dplyr` contexts)
  - `is_original`: Various memento-type testers (useful in `purrr` or
    `dplyr` contexts)
  - `is_timemap`: Various memento-type testers (useful in `purrr` or
    `dplyr` contexts)
  - `is_timegate`: Various memento-type testers (useful in `purrr` or
    `dplyr` contexts)

**Scrape API**

  - `ia_retrieve`: Retrieve directory listings for Internet Archive objects by identifier
  - `ia_scrape`: Internet Archive Scraping API Access
  - `ia_scrape_has_more`: ‘ia\_scrape()’ Pagination Helpers
  - `ia_scrape_next_page`: Internet Archive Scraping API Access

## Installation

``` r
devtools::install_github("hrbrmstr/wayback")
```

## Usage

``` r
library(wayback)
library(tidyverse)

# current verison
packageVersion("wayback")
```

    ## [1] '0.3.0'

### Memento-ish things

``` r
archive_available("https://yahoo.com/")
```

    ## # A tibble: 1 x 5
    ##   url                available closet_url                                                    timestamp           status
    ##   <chr>              <lgl>     <chr>                                                         <dttm>              <chr> 
    ## 1 https://yahoo.com/ TRUE      http://web.archive.org/web/20180917134123/https://www.yahoo.… 2018-09-17 00:00:00 200

``` r
get_mementos("https://yahoo.com/")
```

    ## # A tibble: 0 x 0

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
    ## $ timestamp  <dttm> 1996-10-17, 1996-10-17, 1996-10-17, 1996-10-17, 1996-10-17, 1996-10-17, 1996-10-17, 1996-10-20,...
    ## $ original   <chr> "http://www2.yahoo.com:80/", "http://www2.yahoo.com:80/", "http://www2.yahoo.com:80/", "http://w...
    ## $ mimetype   <chr> "text/html", "text/html", "text/html", "text/html", "text/html", "text/html", "text/html", "text...
    ## $ statuscode <chr> "200", "200", "200", "200", "200", "200", "200", "200", "200", "200"
    ## $ digest     <chr> "LOB7746BGHENCUWDONHQM7NPHUSNKZRN", "LOB7746BGHENCUWDONHQM7NPHUSNKZRN", "LOB7746BGHENCUWDONHQM7N...
    ## $ length     <dbl> 1811, 1811, 1811, 1811, 1811, 1811, 1811, 1888, 1954, 1950

``` r
res <- read_memento("https://yahoo.com/")
res <- stringi::stri_split_lines(res)[[1]]
res <- c(head(res, 6), tail(res, 8))
cat(paste0(res, collaspe="\n"))
```

    ## <!DOCTYPE html><html style="background-color:#EEEEEE" prefix="og: http://ogp.me/ns# article: http://ogp.me/ns/article#" itemscope itemtype="http://schema.org/Article"><!--50.252.233.22--><!--libcurl/7.54.0 r-curl/3.2 httr/1.3.1--><head><meta http-equiv="Content-Type" content="text/html;charset=utf-8"/><meta name="robots" content="index,noarchive"/><meta property="twitter:card" content="summary"/><meta property="twitter:site" content="@archiveis"/><meta property="og:type" content="article"/><meta property="og:site_name" content="archive.is"/><meta property="og:url" content="http://archive.is/YWPHo" itemprop="url"/><meta property="og:title" content="Yahoo"/><meta property="twitter:title" content="Yahoo"/><meta property="twitter:description" content="archived 16 Dec 2017 07:40:22 UTC" itemprop="description"/><meta property="article:published_time" content="2017-12-16T07:40:22Z" itemprop="dateCreated"/><meta property="article:modified_time" content="2017-12-16T07:40:22Z" itemprop="dateModified"/><link rel="image_src" href="https://archive.is/YWPHo/ae692322efb331c386efc2fc522716138ebc8317/scr.png"/><meta property="og:image" content="https://archive.is/YWPHo/ae692322efb331c386efc2fc522716138ebc8317/scr.png" itemprop="image"/><meta property="twitter:image" content="https://archive.is/YWPHo/ae692322efb331c386efc2fc522716138ebc8317/scr.png"/><meta property="twitter:image:src" content="https://archive.is/YWPHo/ae692322efb331c386efc2fc522716138ebc8317/scr.png"/><meta property="twitter:image:width" content="1024"/><meta property="twitter:image:height" content="768"/><link rel="icon" href="//www.google.com/s2/favicons?domain=www.yahoo.com"/><link rel="canonical" href="https://archive.is/YWPHo"/><link rel="bookmark" href="http://archive.today/20171216074022/https://www.yahoo.com/"/><title>Yahoo</title><style type="text/css">@font-face {
    ##  font-family:Advance-Fp2;
    ##  src: url('http://archive.is/YWPHo/138ab1ce83f4739165234c6ec2b47dd6aee02bc4') format('woff'), url('http://archive.is/YWPHo/d2abc5de92479d25e5b41c95e43721346361516f.ttf') format('truetype');
    ##  }
    ##  @font-face {
    ##  font-family:Yglyphs-legacy;
    ##    var f = function () {var s = d.getElementsByTagName("script")[0]; s.parentNode.insertBefore(ts, s);};
    ##    if (w.opera == "[object Opera]") { d.addEventListener("DOMContentLoaded", f, false); } else { f(); }
    ##  })(document, window, "topmailru-code");
    ##  document.cookie="_ga=GA1.2.661111166."+Math.floor((new Date()).getTime()/1000)+";expires="+(new Date((new Date()).getTime()+2*60*60*1000)).toUTCString()+";path=/";
    ##  </script><noscript><div style="position:absolute;left:-10000px;">
    ##  <img src="//top-fwz1.mail.ru/counter?id=2825109;js=na" style="border:0;" height="1" width="1"/>
    ##  </div></noscript>
    ##  <img width="1" height="1" src="http://50.252.233.22.us.NCP2.208024736.pixel.archive.is/pixel.gif"/><div style="padding:200px 0;min-width:1028px;background-color:#EEEEEE"></div></center></body></html>

### Scrape API

``` r
ia_scrape("lemon curry")
```

    ## <ia_scrape object>
