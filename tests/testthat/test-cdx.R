context("cdx API functionality")
test_that("cdx API connects and produces a tibble", {

  expect_silent(res <- cdx_basic_query("rud.is/b"))
  expect_that(res, is_a("tbl_df"))
  expect_that(res, is_a("data.frame"))

})

test_that("cdx API fails on invalid or missing input", {

  expect_error(res <- cdx_basic_query(""))
  expect_error(res <- cdx_basic_query())
  expect_error(res <- cdx_basic_query(1337))
  expect_error(res <- cdx_basic_query(NA))
  expect_error(res <- cdx_basic_query(url = NULL))
  expect_error(res <- cdx_basic_query(NULL))

})
