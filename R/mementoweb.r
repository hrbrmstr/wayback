#' Read a resource directly from the Time Travel MementoWeb
#'
#' This uses the MementoWeb [Time Travel Service](http://timetravel.mementoweb.org/about/)
#' to directly retrieve retrieve URL content. You get (slightly augmented by MementoWeb)
#' orignal URL content from at or near the timestamp you specify.
#'
#' This can be helpful if you find the resource you need is gone today but still
#' exists in the memory of the internet.
#'
#' @md
#' @param url URL to retrieve information for
#' @param timestamp timestamp to use when checking for availability.If you don't pass in a
#'        valid R "time-y" object, you will need to ensure the character string you
#'        provide is in a valid subset of `YYYYMMDDhhmmss`.
#' @param as How you want the content returned. One of "`text`", "`raw`" or "`parsed`"
#'        (it uses `httr::content()` to do the heavy lifting).
#' @return The specified content type
#' @references [Time Travel API](http://timetravel.mementoweb.org/guide/api/)
#' @export
#' @examples \dontrun{
#' library(htmltools)
#' library(rvest)
#'
#' yahoo_old <- read_memento("http://yahoo.com", "2010")
#'
#' html_print(HTML(yahoo_old)) # opens browser
#'
#' pg <- xml2::read_html(yahoo_old)
#' html_nodes(pg, "a.x3-large") %>%
#'   html_text()
#' ## Tiger loses one more sponsorship"
#' }
read_memento <- function(url, timestamp=format(Sys.Date(), "%Y"),
                         as = c("text", "raw", "parsed")) {

  as <- match.arg(as, c("text", "raw", "parsed"))

  if (is.null(timestamp)) timestamp <- format(Sys.Date(), "%Y")
  if (is.character(timestamp) && (timestamp == "")) timestamp <- format(Sys.Date(), "%Y")
  if (inherits(timestamp, "POSIXct")) timestamp <- format(timestamp, "%Y%m%d%H%M%S")

  timestamp <- timestamp[1]
  url <- url[1]

  url <- sprintf("http://timetravel.mementoweb.org/memento/%s/%s", timestamp, url)

  res <- httr::GET(url)

  httr::stop_for_status(res)

  httr::content(res, as=as)

}
