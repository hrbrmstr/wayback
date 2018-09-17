#' Retrieve directory listings for Internet Archive objects by identifier
#'
#' Given an object identifier (obtained via [ia_scrape()]), retrieve the
#' directory listing for the item. The `link` column will have URLs that
#' can be retrieved with `download.file()`.
#'
#' @md
#' @param identifier an identifier string obtained via [ia_scrape()].
#' @return data frame of files and links with some metadata
#' @export
#' @examples
#' nasa <- ia_scrape("collection:nasa", count=100L)
#' item <- ia_retrieve(nasa$identifier[1])
#' td <- tempdir()
#' download.file(item$link[1], file.path(td, item$file[1]))
ia_retrieve <- function(identifier) {

  httr::GET(
    url = sprintf("https://archive.org/download/%s", identifier),
    httr::user_agent("R wayback package; <https://gitlab.com/hrbrmstr/wayback>")
  ) -> res

  httr::stop_for_status(res)

  tmp <- httr::content(res, as="parsed", encoding="UTF-8")
  tmp <- rvest::html_node(tmp, "table.directory-listing-table")

  data.frame(
    file = rvest::html_text(rvest::html_nodes(tmp, xpath=".//td[1]/a[1]")[-1]),
    link = sprintf(
      fmt = "https://archive.org/download/%s/%s",
      identifier,
      rvest::html_attr(rvest::html_nodes(tmp, xpath=".//td[1]/a[1]")[-1], "href")
    ),
    last_mod = rvest::html_text(rvest::html_nodes(tmp, xpath=".//td[2]")[-1]),
    size = rvest::html_text(rvest::html_nodes(tmp, xpath=".//td[3]")[-1]),
    stringsAsFactors = FALSE
  ) -> tmp

  class(tmp) <- c("tbl_df", "tbl", "data.frame")

  tmp

}
