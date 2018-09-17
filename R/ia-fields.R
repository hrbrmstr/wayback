.ia_fields <- function() {

  httr::GET(
    url = "https://archive.org/services/search/v1/fields",
    httr::accept_json(),
    httr::user_agent("R wayback package; <https://gitlab.com/hrbrmstr/wayback>")
  ) -> res

  httr::stop_for_status(res)

  out <- httr::content(res, as="parsed", encoding="UTF-8")

  unlist(out$fields, use.names = FALSE)

}

#' Return a character vector of available return fields for [ia_scrape()]
#'
#' @md
#' @export
ia_fields <- memoise::memoise(.ia_fields)
