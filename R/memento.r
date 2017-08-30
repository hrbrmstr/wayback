#' Retrieve site mementos from the Internet Archive
#'
#' Mementos are prior versions of web pages that have been cached from web crawlers.
#' They can be found in web archives (such as the Internet Archive) or systems that
#' support versioning such as wikis or revision control systems.
#'
#' @param url URL to retrieve information for
#' @param timestamp (optional) timestamp to use when checking for availability.  If not specified,
#'        the most recenty available capture in Wayback is returned. If you don't pass in a
#'        valid R "time-y" object, you will need to ensure the character string you
#'        provide is in a valid subset of `YYYYMMDDhhmmss`.
#' @export
#' @examples \dontrun{
#' rproj_mnto <- get_mementos("https://www.r-project.org/")
#'
#' dplyr::glimpse(rproj_mnto)
#' ## Observations: 7
#' ## Variables: 3
#' ## $ link <chr> "http://www.r-project.org/", "http://web.archive.org/web/timemap/...
#' ## $ rel  <chr> "original", "timemap", "timegate", "first memento", "prev memento...
#' ## $ ts   <dttm> NA, NA, NA, 2000-06-20 19:56:31, 2017-08-29 04:41:15, 2017-08-30...
#' }
get_mementos <- function(url, timestamp = format(Sys.Date(), "%Y")) {

  base_url <- "http://web.archive.org/web/%s%s"

  if (!missing(timestamp)) {
    if (inherits(timestamp, "Date")) {
      timestamp <- format(timestamp, "%Y%m%d/")
    } else if (inherits(timestamp, "POSIXt")) {
      timestamp <- format(timestamp, "%Y%m%d%H%M%S/")
    } else {
      timestamp <- ""
    }
  } else {
    timestamp <- ""
  }

  url <- sprintf(base_url, timestamp, url)
  res <- httr::HEAD(url, httr::user_agent(UA_WAYBACK))


  httr::stop_for_status(res)

  stri_split_fixed(res$all_headers[[2]]$headers$link, '", ') %>%
    flatten_chr() %>%
    map(stri_split_fixed, "; ") %>%
    map(flatten_chr) %>%
    map_df(function(x) {
      link <- stri_replace_all_regex(x[1], "^<|>$", "")
      rel <- stri_replace_all_regex(x[2], '^rel="|"$', "")
      ts <- NA
      if (length(x == 3)) {
        if (grepl("datetime", x[3])) {
          ts <- stri_replace_all_regex(x[3], '^datetime="|"$', "")
          ts <- anytime(ts)
        }
      }
      data_frame(link=link, rel=rel, ts=ts)
    })

}

