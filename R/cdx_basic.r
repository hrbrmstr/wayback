#' Perform a basic/limited Internet Archive CDX resource query for a URL
#'
#' @param url URL to query
#' @param matchType The CDX server can also return results matching a certain
#'   prefix, a certain host or all subdomains
#' @param limit Maximum number of results to return (first N results). Use a
#'   negative number to retrieve the last N results.
#'
#' @details If a vector of numeric values is provided to \code{limit} then the
#'   smallest value will be used. Values of \code{limit} are coerced using
#'   \code{as.integer}.
#'
#' @return a \code{tibble} of the result
#'
#' @import httr
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr mutate
#' @importFrom purrr flatten_chr
#' @importFrom anytime anytime
#' @importFrom tibble as_tibble
#' @importFrom lazyeval interp
#' @importFrom stats setNames
#' @importFrom utils URLencode
#'
#' @export
#' @examples
#' cdx_basic_query("http://example.com")
cdx_basic_query <- function(url, matchType = c("exact", "prefix", "host", "domain"), limit = 1e4L) {

  if (missing(url) || is.null(url) || is.na(url) || url == "" || !is.character(url)) {
    stop("Invalid or missing URL.")
  }

  if (is.null(matchType) || is.na(matchType)) {
    stop("Invalid matchType -- options are exact, prefix, host, or domain.")
  }
  matchType <- match.arg(matchType)

  limit <- as.integer(limit)
  if (is.null(limit) || is.na(limit) || length(limit) == 0 || limit == 0L) {
    stop("Invalid limit requested.")
  }
  limit <- min(limit, 15e4L) # CDX limit is 15e4L

  url_enc <- utils::URLencode(url)

  res <- httr::GET("http://web.archive.org/cdx/search/cdx",
             query = list(url = url_enc, output = "json", matchType = matchType, limit = limit),
             httr::user_agent(UA_WAYBACK)
  )

  httr::stop_for_status(res)

  if (httr::http_type(res) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }

  res <- httr::content(res, as = "text", encoding = "UTF-8")

  res <- jsonlite::fromJSON(res,
                            simplifyVector = TRUE,
                            simplifyDataFrame = TRUE)

  res <- tibble::as_tibble(res)

  res <- stats::setNames(res[-1, ], purrr::flatten_chr(res[1, ]))

  if ("timestamp" %in% colnames(res)) {
    res <- dplyr::mutate_(res, "timestamp" = lazyeval::interp(~anytime::anytime(t), t = quote(timestamp)))
  }

  if ("length" %in% colnames(res)) {
    res <- dplyr::mutate_(res, "length" = lazyeval::interp(~as.numeric(l), l = quote(length)))
  }

  res

}
