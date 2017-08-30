#' Retrieve site mementos from the Internet Archive
#'
#' Mementos are prior versions of web pages that have been cached from web crawlers.
#' They can be found in web archives (such as the Internet Archive) or systems that
#' support versioning such as wikis or revision control systems.
#'
#' It's possible that a memento list could be large and contain an entry
#' for the next "page" of mementos.
#'
#' TODO Not sure we should handle that ^^ here since this is a free service and
#' is already pretty taxed. If the user needs it they can request from a new
#' timestamp. But I'm not committed to this concept.
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

  if (missing(url) || is.null(url) || is.na(url) || url == "" || !is.character(url)) {
    stop("Invalid or missing URL.")
  }

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

  stringi::stri_split_fixed(res$all_headers[[2]]$headers$link, '", ') %>%
    purrr::flatten_chr() %>%
    purrr::map(stringi::stri_split_fixed, "; ") %>%
    purrr::map(purrr::flatten_chr) %>%
    purrr::map_df(function(x) {
      link <- stringi::stri_replace_all_regex(x[1], "^<|>$", "")
      rel <- stringi::stri_replace_all_regex(x[2], '^rel="|"$', "")
      ts <- NA
      if (length(x == 3)) {
        if (grepl("datetime", x[3])) {
          ts <- stringi::stri_replace_all_regex(x[3], '^datetime="|"$', "")
          ts <- anytime::anytime(ts)
        }
      }
      tibble::data_frame(link = link, rel = rel, ts = ts)
    })

}

