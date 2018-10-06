context("webService")
# Required, otherweise the unit tests are not working
library(httr)
library(jsonlite)
library(plyr)

## User input
test_that("Wrong user input is detected from fetchByMunicipality()", {
  expect_error(fetchByMunicipality("a", 2012))
  expect_error(fetchByMunicipality(1440, "b"))
  expect_error(fetchByMunicipality(1440, list(2012, 2013, 2014)))
  expect_error(fetchByMunicipality(list(1440, 1441, 1442), 2012))
  expect_error(fetchByMunicipality(data.frame(), 2012))
  expect_error(fetchByMunicipality(1440, list()))
})

test_that("Wrong user input is detected from fetchByKpi()", {
  expect_error(fetchByKpi("N00914", 1440, list(2010, 2011, 2012)))
  expect_error(fetchByKpi(c("N00914,U00405"), 1440, list(2010, 2011, 2012)))
  expect_error(fetchByKpi(list("N00914,U00405"), 1440, c(2010, 2011, 2012)))
  expect_error(fetchByKpi(list("N00914,U00405"), c(1440, 1440), list(2010, 2011, 2012)))
  expect_error(fetchByKpi(list("N00914,U00405"), data.frame(), list(2010, 2011, 2012)))
  expect_error(fetchByKpi(list(), 1440, list(2010, 2011, 2012)))
  expect_error(fetchByKpi("N00914", 1440))
  expect_error(fetchByKpi("N00914", c()))
  expect_error(fetchByKpi(list(), 1440))
})

## Functionality
test_that("fetchMunicipalities() is working", {
  df = fetchMunicipalities()
  expect_true(is.data.frame(df))
  expect_equal(df[5, "values.id"], "1984")
})

test_that("fetchKpis() is working", {
  df = fetchKpis()
  expect_true(is.data.frame(df))
  expect_equal(df[6, "member_id"], "U28119")
})

test_that("fetchByMunicipalities() is working", {
  df = fetchByMunicipality(1440, 2012)
  expect_true(is.data.frame(df))
  expect_equal(df[5, "values.kpi"], "N00011")
})

test_that("fetchByKpi() is working", {
  df = fetchByKpi(list("N00914", "U00405"), 1440, list(2010, 2011, 2012))
  expect_true(is.data.frame(df))
  expect_equal(df[5, "values.kpi"], "U00405")
})
