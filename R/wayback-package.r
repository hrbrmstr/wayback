#' Tools to Work with Internet Archive Wayback Machine APIs
#'
#' The 'Internet Archive' provides access to millions of cached sites. Methods
#' are provided to access these cached resources through the 'APIs' provided by
#' the 'Internet Archive' and also content from 'MementoWeb'.
#'
#' @md
#' @name wayback
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @import purrr httr anytime stringi
#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes html_text html_attr
#' @importFrom tibble as_tibble data_frame
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr mutate select
#' @importFrom memoise memoise
#' @importFrom anytime anytime
#' @importFrom lazyeval interp
#' @importFrom stats setNames
#' @importFrom utils URLencode
NULL
