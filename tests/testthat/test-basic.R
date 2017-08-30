context("Basic functionality")
test_that("core functions work", {

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

  res <- archive_available("http://yahoo.com/", "2017")
  expect_equal(res$available[1], TRUE)

  res <- get_mementos("http://yahoo.com", timestamp = format(Sys.Date(), "%Y"))
  expect_that(res, is_a("data.frame"))

  testthat::skip_on_travis()

  res <- read_memento("http://yahoo.com", "2010")
  expect_that(res, is_a("character"))

})
