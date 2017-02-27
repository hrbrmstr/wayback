#' Perform a basic/limited Internet Archive CDX resource query for a URL
#'
#' @param url URL to query
#' @export
cdx_basic_query <- function(url) {

  res <- GET("http://web.archive.org/cdx/search/cdx",
             query=list(url=url, output="json"))

  httr::stop_for_status(res)

  res <- httr::content(res, as="text", encoding="UTF-8")

  res <- jsonlite::fromJSON(res, simplifyVector=TRUE, simplifyDataFrame=TRUE)

  res <- as_tibble(res)

  res <- setNames(res[-1,], flatten_chr(res[1,]))

  if ("timestamp" %in% colnames(res)) {
    res <- mutate(res, timestamp=anytime(timestamp))
  }

  if ("length" %in% colnames(res)) {
    res <- mutate(res, length=as.numeric(length))
  }

  res

}
