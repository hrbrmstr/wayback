#' Does the Internet Archive have a URL cached?
#'
#' @param url URL to retrieve information for
#' @param timestamp (optional) timestamp use when checking for availability
#' @export
archive_available <- function(url, timestamp) {

  params <- list(url=url)

  if (!missing(timestamp)) {
    if (inherits(timestamp, "Date")) {
      timestamp <- format(timestamp, "%Y%m%d")
    } else if (inherits(timestamp, "POSIXt")) {
      timestamp <- format(timestamp, "%Y%m%d%H%M%S")
    }
    params <-  c(params, timestamp=timestamp)
  }

  res <- httr::GET("http://archive.org/wayback/available", query=params)

  httr::stop_for_status(res)

  res <- httr::content(res, as="text", encoding="UTF-8")

  res <- jsonlite::fromJSON(res)

  if (length(res$archived_snapshots) == 0) {
    data_frame(url=url, available=FALSE, closest_url=NA, timestamp=NA, status=NA)
  } else {
    data_frame(
      url = url,
      available = res$archived_snapshots$closest$available,
      closet_url = res$archived_snapshots$closest$url,
      timestamp = anytime(res$archived_snapshots$closest$timestamp),
      status = res$archived_snapshots$closest$status
    )
  }

}
