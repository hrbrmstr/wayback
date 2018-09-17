#' Perform a basic/limited Internet Archive CDX resource query for a URL
#'
#' CDX files are "Content Index" files. The Wayback CDX server is a standalone HTTP
#' servlet that serves the index that the Wayback machine uses to lookup captures.
#'
#' The index format is known as 'cdx' and contains various fields representing the capture,
#' usually sorted by url and date. <http://archive.org/web/researcher/cdx_file_format.php>.
#'
#' @param url URL/resource to query for
#' @param match_type The CDX server can also return results matching a certain
#'        prefix, a certain host or all subdomains. Can be one of
#'        `"exact"`, `"prefix"`, `"host"`, or `"domain"` (defaults to `exact`).
#' @param limit Maximum number of results to return (first _n_ results). Use a
#'        negative number to retrieve the last _n_ results. Default is `10,000`.
#'
#' @return data frame
#'
#' @md
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
#' @examples \dontrun{
#' rproj_basic <- cdx_basic_query("https://www.r-project.org/")
#'
#' dplyr::glimpse(rproj_basic)
#' ## Observations: 10,000
#' ## Variables: 7
#' ## $ urlkey     <chr> "org,r-project)/", "org,r-project)/", "org,r-project)/"...
#' ## $ timestamp  <dttm> 2000-06-20, 2000-08-16, 2000-10-12, 2000-11-10, 2000-1...
#' ## $ original   <chr> "http://www.r-project.org:80/", "http://www.r-project.o...
#' ## $ mimetype   <chr> "text/html", "text/html", "text/html", "text/html", "te...
#' ## $ statuscode <chr> "200", "200", "200", "200", "200", "200", "200", "200",...
#' ## $ digest     <chr> "XDIHHFDLIWSZFHYHT453ZL5FYPCKFF6Z", "SRO3WSKQS6HST4PQY7...
#' ## $ length     <dbl> 4894, 5027, 589, 581, 582, 596, 590, 592, 592, 592, 563...
#' }
cdx_basic_query <- function(url, match_type = c("exact", "prefix", "host", "domain"), limit = 1e4L) {

  if (missing(url) || is.null(url) || is.na(url) || url == "" || !is.character(url)) {
    stop("Invalid or missing URL.")
  }

  if (is.null(match_type) || is.na(match_type)) {
    stop("Invalid match type -- options are exact, prefix, host, or domain.")
  }
  match_type <- match.arg(match_type)

  limit <- as.integer(limit)
  if (is.null(limit) || is.na(limit) || length(limit) == 0 || limit == 0L) {
    stop("Invalid limit requested.")
  }
  limit <- min(limit, 15e4L) # NOTE: CDX max limit is 15e4L

  url_enc <- utils::URLencode(url)

  res <- httr::GET("http://web.archive.org/cdx/search/cdx",
             query = list(url = url_enc, output = "json", matchType = match_type, limit = limit),
             httr::user_agent(UA_WAYBACK)
  )

  httr::stop_for_status(res)

  if (httr::http_type(res) != "application/json") {
    stop("The Wayback API did not return valid JSON", call. = FALSE)
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
