#' Does the Internet Archive have a URL cached?
#'
#' This performs a simple test to see if a  given url is archived and currenlty accessible
#' in the Wayback Machine.
#'
#' If a resource is found, the returned data frame will have `available` set to `TRUE`
#' and the `closest_url`, `timestamp` and `status` fields populated. If the resource is
#' not found, the `url` field will be populated along with a `status` field that has a
#' value of "`404`".
#'
#' @md
#' @param url URL to retrieve information for
#' @param timestamp (optional) timestamp to use when checking for availability.  If not specified,
#'        the most recenty available capture in Wayback is returned. If you don't pass in a
#'        valid R "time-y" object, you will need to ensure the character string you
#'        provide is in a valid subset of `YYYYMMDDhhmmss`.
#' @return data frame
#' @references <https://archive.org/help/wayback_api.php>
#' @export
#' @importFrom purrr %||%
#' @examples \dontrun{
#' rproj_avail <- archive_available("https://www.r-project.org/")
#'
#' str(rproj_avail)
#' ## Classes ‘tbl_df’, ‘tbl’ and 'data.frame':	1 obs. of  5 variables:
#' ##  $ url       : chr "https://www.r-project.org/"
#' ##  $ available : logi TRUE
#' ##  $ closet_url: chr "http://web.archive.org/web/20170830061210/http://www.r-project.org/"
#' ##  $ timestamp : POSIXct, format: "2017-08-30"
#' ##  $ status    : chr "200"
#' }
archive_available <- function(url, timestamp) {

  params <- list(url = url)

  if (!missing(timestamp)) {
    if (inherits(timestamp, "Date")) {
      timestamp <- format(timestamp, "%Y%m%d")
    } else if (inherits(timestamp, "POSIXt")) {
      timestamp <- format(timestamp, "%Y%m%d%H%M%S")
    }
    params <-  c(params, timestamp=timestamp)
  }

  res <- httr::GET("http://archive.org/wayback/available", query = params)

  httr::stop_for_status(res)

  res <- httr::content(res, as = "text", encoding = "UTF-8")

  res <- jsonlite::fromJSON(res)

  if (length(res$archived_snapshots) == 0) {
    data_frame(url=url, available=FALSE, closest_url=NA, timestamp=NA, status="404")
  } else {
    cl <- res$archived_snapshots$closest
    suppressWarnings(data_frame(
      url = url,
      available = cl[["available"]] %||% NA,
      closet_url = res$archived_snapshots$closest$url,
      timestamp = anytime(res$archived_snapshots$closest$timestamp),
      status = res$archived_snapshots$closest$status
    ))
  }

}
