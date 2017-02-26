#' Retrieve a timemap for a URL
#'
#' @param url Either an existig timemap URL or a plain resource URL
#' @export
get_timemap <- function(url) {

  if (!grepl(url, "^http://web.archive.org")) {
    url <- sprintf("http://web.archive.org/web/timemap/link/%s", url)
  }

  res <- httr::GET(url)

  httr::stop_for_status(res)

  res <- httr::content(res, as="text", encoding="UTF-8")

  stri_split_fixed(res, ",\n") %>%
    flatten_chr() %>%
    map_df(function(x) {
      link <- stri_match_first_regex(x, "^<(.*)>;")[,2]
      parts <- flatten_chr(stri_split_fixed(x, "; "))
      stri_match_all_regex(parts[-1], '([[:alpha:]]+)="(.*)"') %>%
        map(~.[,2:3]) %>%
        map(~as.list(set_names(.[2], .[1]))) %>%
        flatten_df() %>%
        mutate(link=link)
    })

}

