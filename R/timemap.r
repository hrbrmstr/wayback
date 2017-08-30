#' Retrieve a timemap for a URL
#'
#' A TimeMap, as defined in the Memento protocol ([RFC 7089](http://mementoweb.org/guide/rfc/)),
#' provides an overview of all Mementos (and their archival/version datetimes) known to the
#' responding server.
#'
#' A TimeMap (URI-T) for an Original Resource (URI-R) is a machine-readable document that
#' lists the Original Resource itself, its TimeGate, and its Mementos as well as associated
#' metadata such as archival datetime for Mementos. TimeMaps are exposed by systems that
#' host prior versions of Original Resources, and allow for batch discovery of Mementos,
#'
#' TimeMaps are serialized according to the syntax specified for the value of the HTTP Link
#' header. That format is introduced in [RFC 5988](http://tools.ietf.org/html/rfc5988),
#' Web Linking RFC, and has media type `application/link-format`.
#'
#' Each timemap entry contains:
#'
#' - `rel` : the type of timemap record (i.e. it describes the relationship between the current entry and the linked resource). See [Section 2.2](http://mementoweb.org/guide/rfc/#rfc.section.2.2) for more information.
#' - `link` : can be the direct link to the original resource or links to the archived copy
#' - `type` : if provided, the type of link
#' - `from` : if provided, a timestamp for the `rel` == "`self`" record (should be `NA` for others)
#' - `datetime` : the timestamp for the memento record
#'
#' @md
#' @param url Either an existing timemap URL or a plain resource URL
#' @param seconds (default is `180`) This is an expensive operation for the Internet Archive
#'     and it can take well-above this 3-minute setting for query results to be
#'     delivered. It's highly suggested you monitor your experience and adjust accordingly.
#' @return data frame of mementos
#' @note if a supplied resource has many entries, this call can take a while
#' @export
#' @examples \dontrun{
#' rproj_tm <- get_timemap("https://www.r-project.org/")
#'
#' unique(rproj_tm$rel)
#' ## [1] "original"      "self"          "timegate"      "first memento" "memento"
#'
#' dplyr::glimpse(rproj_tm)
#' ## Observations: 11,886
#' ## Variables: 5
#' ## $ rel      <chr> "original", "self", "timegate", "first memento", "memento", "mement...
#' ## $ link     <chr> "http://www.r-project.org:80/", "http://web.archive.org/web/timemap...
#' ## $ type     <chr> NA, "application/link-format", NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
#' ## $ from     <chr> NA, "Tue, 20 Jun 2000 19:56:31 GMT", NA, NA, NA, NA, NA, NA, NA, NA...
#' ## $ datetime <chr> NA, NA, NA, "Tue, 20 Jun 2000 19:56:31 GMT", "Wed, 16 Aug 2000 09:5...
#' }
get_timemap <- function(url, seconds = 180) {

  if (length(url) > 1) {
    warning("More than one URL provided. Only using the first URL")
    url <- url[1]
  }

  if (!grepl(url, "^http://web.archive.org")) {
    url <- sprintf("http://web.archive.org/web/timemap/link/%s", url)
  }

  res <- httr::GET(url, timeout(seconds))

  httr::stop_for_status(res)

  res <- httr::content(res, as="text", encoding="UTF-8")

  stri_split_fixed(res, ",\n") %>%
    flatten_chr() %>%
    map_df(function(x) {
      link <- stri_match_first_regex(x, "^<(.*)>;")[,2]
      parts <- flatten_chr(stri_split_fixed(x, "; "))
      stri_match_all_regex(parts[-1], '([[:alpha:]]+)="(.*)"') %>%
        purrr::map(~.[,2:3]) %>%
        purrr::map(~as.list(set_names(.[2], .[1]))) %>%
        flatten_df() %>%
        mutate(link=link)
    })

}
