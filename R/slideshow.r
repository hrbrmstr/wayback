#' Generate a htmlwidgets slideshow of memento snapshots
#'
#' **WARNING**: this function requires that you have correctly set up:
#' * docker
#' * splashr
#'
#' @md
#' @param url URL to retrieve information for
#'
#' @return slick.js image carousel htmlwidget
#' @export
#'
#' @examples \dontrun{
#' slideshow("http://rstats.org")
#' }
slideshow <- function(url) {

  # clean up any running splash instance that can be stopped
  on.exit({
    if (exists("splash_container") && suppressMessages(splashr::splash_active())) {
      message("<splashr> Stopping splashhttpd docker image.")
      splashr::stop_splash(splash_container[[1]])
    }
  })

  # this function is entirely dependent on splashr
  # if it isn't running, try to start it
  if (!suppressMessages(splashr::splash_active())) {
    message("<splashr> Starting splashhttpd docker image.")
    splash_container <- purrr::safely(splashr::start_splash)() %>% purrr::compact()
    stopifnot(inherits(splash_container[[1]], "container"))
  }

  # protect against failures
  safe_png <- purrr::safely(splashr::render_png)

  # poll archive.org for mementos for url
  site_hist <- get_mementos(url)

  # image snapshots
  # site_hist <- dplyr::filter_(site_hist, lazyeval::interp(~is_memento(r), r = quote(rel))) %>%
  #   dplyr::mutate(site = purrr::map(link, ~safe_png(url = .)))
  ## using pbapply for a progress bar as the snapshots take a while
  mementos <- dplyr::filter_(site_hist, lazyeval::interp(~is_memento(r), r = quote(rel)))
  message("<splashr> Creating snapshots of mementos. This may take a while.")
  spng <- pbapply::pblapply(as.list(mementos$link), function(l) safe_png(url = l))

  # non-null responses only
  non_null <- purrr::map(spng, purrr::compact) %>% purrr::flatten()

  # sometime the archive may fail (e.g. 504)
  errors <- non_null[names(non_null) == "error"]
  if (length(errors) > 0) message("<splashr> Errors encountered. Consider re-running.")

  # write successful images to temp directory
  # NOTE: remember that lapply uses lazy-evaluation,
  # so tempfile needs to be called explicitly in each
  imgs <- lapply(non_null[names(non_null) == "result"],
                 function(i) {
                   magick::image_write(i, path = tempfile(fileext = ".png"))
                 })

  # create the slideshow
  return(slickR::slickR(obj = unname(unlist(imgs))))

}
