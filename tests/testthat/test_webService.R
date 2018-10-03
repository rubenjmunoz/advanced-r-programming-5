context("webService")

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
  expect_true(is.data.frame(fetchMunicipalities()))
})

test_that("fetchKpis() is working", {
  expect_true(is.data.frame(fetchKpis()))
})

test_that("fetchMunicipalities() is working", {
  expect_true(is.data.frame(fetchByMunicipality(1440, 2012)))
})

test_that("fetchByKpi() is working", {
  expect_true(is.data.frame(fetchByKpi(list("N00914", "U00405"), 1440, list(2010, 2011, 2012))))
})
