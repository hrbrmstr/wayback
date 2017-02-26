#' @export
get_mementos <- function(url, timestamp) {

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

  res <- HEAD(sprintf(base_url, timestamp, url))

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

