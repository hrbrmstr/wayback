#' Retrieve site mementos
#'
#' It's possible that a memento list could be large and contain an entry
#' for the next "page" of mementos.
#'
#' TODO Not sure we should handle that ^^ here since this is a free service and
#' is already pretty taxed. If the user needs it they can request from a new
#' timestamp. But I'm not committed to this concept.
#'
#' @param url URL to retrieve information for
#' @param timestamp (optional) timestamp use when checking for availability
#' @export
get_mementos <- function(url, timestamp) {

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

