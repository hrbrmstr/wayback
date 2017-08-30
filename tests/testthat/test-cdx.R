context("CDX API functionality")
test_that("CDX API connects and produces a tibble with valid inputs", {

  testthat::skip_on_cran()
  testthat::skip_on_appveyor()

  # ensure HTTP is available prior to testing
  skip_if_not(identical(
    httr::status_code(
      httr::GET("http://rud.is/b",
                httr::user_agent("wayback 0.2.0 tests"))
    ),
    200L),
    "HTTP connection failed"
  )

  ## NOTE: occasionally a timestamp returns NA, which causes tibble to complain about coerced NA
  ##       this likely isn't really a problem, so warnings are suppressed for these tests

  test_URL <- "http://archive.org"

  # basic usage (lots of rows)
  suppressWarnings(res <- cdx_basic_query(test_URL))
  expect_that(res, is_a("tbl_df"))
  expect_that(res, is_a("data.frame"))

  ## NOTE: testing with limit = 10 for speed

  # expect_silent(res <- cdx_basic_query(test_URL)) # warnings could be okay
  suppressWarnings(res <- cdx_basic_query(test_URL, limit = 10))
  expect_that(res, is_a("tbl_df"))
  expect_that(res, is_a("data.frame"))
  expect_lte(nrow(res), 10)
  expect_gte(nrow(res), 0)

  # expect_silent(res <- cdx_basic_query(test_URL, matchType = "exact")) # warnings could be okay
  suppressWarnings(res <- cdx_basic_query(test_URL, limit = 10, match_type = "exact"))
  expect_that(res, is_a("tbl_df"))
  expect_that(res, is_a("data.frame"))
  expect_lte(nrow(res), 10)
  expect_gte(nrow(res), 0)

  # expect_silent(res <- cdx_basic_query(test_URL, matchType = "prefix")) # warnings could be okay
  suppressWarnings(res <- cdx_basic_query(test_URL, limit = 10, match_type = "prefix"))
  expect_that(res, is_a("tbl_df"))
  expect_that(res, is_a("data.frame"))
  expect_lte(nrow(res), 10)
  expect_gte(nrow(res), 0)

  # expect_silent(res <- cdx_basic_query(test_URL, matchType = "host")) # warnings could be okay
  suppressWarnings(res <- cdx_basic_query(test_URL, limit = 10, match_type = "host"))
  expect_that(res, is_a("tbl_df"))
  expect_that(res, is_a("data.frame"))
  expect_lte(nrow(res), 10)
  expect_gte(nrow(res), 0)

  # expect_silent(res <- cdx_basic_query(test_URL, matchType = "domain")) # warnings could be okay
  suppressWarnings(res <- cdx_basic_query(test_URL, limit = 10, match_type = "domain"))
  expect_that(res, is_a("tbl_df"))
  expect_that(res, is_a("data.frame"))
  expect_lte(nrow(res), 10)
  expect_gte(nrow(res), 0)

})

context("Helpers")
test_that("is_ helper functions grepl-match correctly", {

  testthat::skip_on_cran()
  testthat::skip_on_travis()
  testthat::skip_on_appveyor()

  memento_types <- c("memento", "first memento", "next memento", "last memento",
                     "prev memento", "original", "timemap", "timegate", "nothing",
                     NA, NULL)

  expect_equal(is_memento(memento_types),
               c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE))
  expect_equal(is_first_memento(memento_types),
               c(FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE))
  expect_equal(is_next_memento(memento_types),
               c(FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE))
  expect_equal(is_prev_memento(memento_types),
               c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE))
  expect_equal(is_last_memento(memento_types),
               c(FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE))
  expect_equal(is_original(memento_types),
               c(FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE, FALSE))
  expect_equal(is_timemap(memento_types),
               c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE))
  expect_equal(is_timegate(memento_types),
               c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE))

})

context("CDX API functionality (failing resolution)")
test_that("CDX API fails on invalid or missing input", {

  testthat::skip_on_cran()
  testthat::skip_on_appveyor()

  test_URL <- "http://archive.org"

  # test @param url
  expect_error(cdx_basic_query(""))
  expect_error(cdx_basic_query())
  expect_error(cdx_basic_query(1337))
  expect_error(cdx_basic_query(NA))
  expect_error(cdx_basic_query(url = NULL))
  expect_error(cdx_basic_query(NULL))

  # test @param matchType
  expect_error(cdx_basic_query(test_URL, match_type = NA))
  expect_error(cdx_basic_query(test_URL, match_type = NULL))
  expect_error(cdx_basic_query(test_URL, match_type = "foo"))
  expect_error(cdx_basic_query(test_URL, match_type = 9))

  #test @param limit
  expect_error(cdx_basic_query(test_URL, limit = 0))
  expect_error(cdx_basic_query(test_URL, limit = NA))
  expect_error(cdx_basic_query(test_URL, limit = NULL))
  expect_error(cdx_basic_query(test_URL, limit = "0"))
  expect_error(suppressWarnings(cdx_basic_query(test_URL, limit = "a")))

  #test @param limit with valid but non-standard input
  res <- cdx_basic_query(test_URL, limit = c(3, 10))
  expect_lte(nrow(res), 3)
  expect_gte(nrow(res), 0)

})
