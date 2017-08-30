#' Various helper tests for memento `rel` values
#'
#' Very useful in a `purrr` or `data_frame` context.
#'
#' @md
#' @param x character vector (ideally from a `rel` `memento` `data_frame` column)
#' @return `logical` vector
#' @export
is_memento <- function(x) { grepl("memento", x, ignore.case=TRUE) }

#' @rdname is_memento
#' @export
is_first_memento <- function(x) { grepl("first memento", x, ignore.case=TRUE) }

#' @rdname is_memento
#' @export
is_next_memento <- function(x) { grepl("next memento", x, ignore.case=TRUE) }

#' @rdname is_memento
#' @export
is_prev_memento <- function(x) { grepl("prev memento", x, ignore.case=TRUE) }

#' @rdname is_memento
#' @export
is_last_memento <- function(x) { grepl("last memento", x, ignore.case=TRUE) }

#' @rdname is_memento
#' @export
is_original <- function(x) { grepl("original", x, ignore.case=TRUE) }

#' @rdname is_memento
#' @export
is_timemap <- function(x) { grepl("timemap", x, ignore.case=TRUE) }

#' @rdname is_memento
#' @export
is_timegate <- function(x) { grepl("timegate", x, ignore.case=TRUE) }
