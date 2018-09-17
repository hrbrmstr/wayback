#' Internet Archive Scraping API Access
#'
#' @md
#' @param query the query; [Lucene-like query](http://www.lucenetutorial.com/lucene-query-syntax.html);
#'        See [IA Advanced Search](https://archive.org/advancedsearch.php) for possible options.
#' @param fields Use [ia_fields()] for an up-to-date listing of possible reutrn fields.
#'        Default is `c("identifier", "addeddate", "title")`.
#' @param sorts sort collations, character vector. Any of the sort fields from the `fields``
#'        endpoint can be specified. If the `identifier`` is specified as a sort field,
#'        it must be the last sort (the function will try to help you out with this if
#'        you forget). A field can have an `asc` or `desc` modifier (separate it from the field
#'        name with a space). The default is `identifier asc` (and is always the implied last collation).
#'        Example: `c("title asc", "publicdata desc")`
#' @param count The number of results to return. _Minimum_ is `100`. Default is `5000`,
#'        _Maximum_ is `9999`; See <https://archive.org/help/aboutsearch.htm> for
#'        information on restrictions. Use [ia_scrape_next_page()] on the return value of
#'        this function (or the result of [ia_scrape_next_page()]) to paginate through
#'        API results until [ia_scrape_next_page()]) returns `NULL` or [ia_scrape_has_more()]
#'        returns `FALSE`.
#' @param summary if `TRUE`, then only the number of results is returned. Default: `FALSE`
#' @references <https://archive.org/help/aboutsearch.htm>
#' @seealso [ia_scrape_next_page()]
#' @export
#' @examples
#' x <- ia_scrape("lemon curry")
ia_scrape <- function(query,
                      fields = c("identifier", "addeddate", "title"),
                      sorts = "identifier asc",
                      count = 5000L,
                      summary = FALSE) {

  fields <- unique(stri_trim_both(fields))
  fields <- match.arg(fields, ia_fields(), several.ok = TRUE)
  fields <- paste0(fields, collapse = ",")

  sorts <- unique(stri_trim_both(sorts))
  id <- which(grepl("^identifier", sorts))
  if (length(id) > 0) {
    if (id != length(sorts)) id <- c(sorts[-id], sorts[id])
  }
  sorts <- paste0(sorts, collapse = ",")

  if (count < 100) count <- 100L
  if (count > 9999) count <- 9999L

  list(
    debug = "false",
    xvar = "production",
    total_only = tolower(as.character(summary)),
    count = as.integer(count),
    fields = fields,
    sorts = sorts,
    q = query
  ) -> params

  httr::GET(
    url = "https://archive.org/services/search/v1/scrape",
    httr::accept_json(),
    httr::user_agent("R wayback package; <https://gitlab.com/hrbrmstr/wayback>"),
    query = params
  ) -> res

  httr::stop_for_status(res)

  out <- httr::content(res, as="parsed", encoding="UTF-8")

  if (summary) {
    return(out$total)
  } else {
    if (length(out$items) > 0) {
      ret <- purrr::map_df(out$items, function(x) {
        lapply(x, function(y) unlist(y)[1])
      })
      attr(ret, "params") <- params
      attr(ret, "cursor") <- out$cursor
      attr(ret, "total") <- out$total
      class(ret) <- c("ia_scrape", "tbl_df", "tbl", "data.frame")
      ret
    } else {
      return(NULL)
    }
  }

}

#' [ia_scrape()] Pagination Helpers
#'
#' @md
#' @param obj an object returned by [ia_scrape_next_page()] or [ia_scrape()]
#' @export
#' @examples
#' x <- ia_scrape("lemon curry", count=100L)
#' if (ia_scrape_has_more(x)) y <- ia_scrape_next_page(x)
ia_scrape_has_more <- function(obj) {
  !is.null(attr(obj, "cursor"))
}

#' @rdname ia_scrape_has_more
#' @export
ia_scrape_next_page <- function(obj) {

  if (!ia_scrape_has_more(obj)) return(NULL)

  params <- attr(obj, "params")
  params$cursor <- attr(obj, "cursor")

  httr::GET(
    url = "https://archive.org/services/search/v1/scrape",
    httr::accept_json(),
    httr::user_agent("R wayback package; <https://gitlab.com/hrbrmstr/wayback>"),
    query = params
  ) -> res

  httr::stop_for_status(res)

  out <- httr::content(res, as="parsed", encoding="UTF-8")
  if (length(out$items) > 0) {
    ret <- purrr::map_df(out$items, function(x) {
      lapply(x, function(y) unlist(y)[1])
    })
    attr(ret, "params") <- attr(obj, "params")
    attr(ret, "cursor") <- out$cursor
    attr(ret, "total") <- out$total
    class(ret) <- c("ia_scrape", "tbl_df", "tbl", "data.frame")
    ret
  } else {
    return(NULL)
  }
}

#' Print method for `ia_scrape` objects
#'
#' @md
#' @param x an `ia_scrape` object
#' @param ... unused
#' @keywords internal
#' @export
print.ia_scrape <- function(x, ...) {
  if (is.null(x)) return(NULL)
  cat("<ia_scrape object>\n")
  cursor <- attr(x, "cursor")
  if (!is.null(cursor)) cat("Cursor: ", cursor, "\n", sep="")
}

