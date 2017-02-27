#' Perform a basic/limited Internet Archive CDX resource query for a URL
#'
#' @param url URL to query
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
#' cdx_basic_query("rud.is/b")
cdx_basic_query <- function(url) {

  if (missing(url) || is.null(url) || is.na(url) || url == "" || !is.character(url)) {
    stop("Invalid or missing URL")
  }

  url_enc <- utils::URLencode(url)

  res <- httr::GET("http://web.archive.org/cdx/search/cdx",
             query = list(url = url_enc, output = "json"),
             httr::user_agent("https://github.com/hrbrmstr/wayback")
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
