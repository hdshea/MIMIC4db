test_that("m4_icu functions work", {
  con <- bigrquery::dbConnect(
    bigrquery::bigquery(),
    project = bigrquery::bq_test_project(),
    quiet = TRUE
  )

  res <- m4_chartevents(con, cohort = 12384098)
  expect_equal(nrow(res), 30036)
  expect_equal(ncol(res), 10)

  res <- m4_chartevents(con, cohort = 15516997, itemlist = 224639)
  expect_equal(nrow(res), 72)
  expect_equal(ncol(res), 10)

  res <- m4_datetimeevents(con, cohort = 15914798)
  expect_equal(nrow(res), 3)
  expect_equal(ncol(res), 9)

  res <- m4_datetimeevents(con, cohort = 15914798, itemlist = 225755)
  expect_equal(nrow(res), 3)
  expect_equal(ncol(res), 9)

  res <- m4_icustays(con, cohort = 12384098)
  expect_equal(nrow(res), 1)
  expect_equal(ncol(res), 8)

  res <- m4_inputevents(con, cohort = 12384098)
  expect_equal(nrow(res), 1274)
  expect_equal(ncol(res), 26)

  res <- m4_inputevents(con, cohort = c(16900375, 15179083), itemlist = 225842)
  expect_equal(nrow(res), 81)
  expect_equal(ncol(res), 26)

  res <- m4_outputevents(con, cohort = 12384098)
  expect_equal(nrow(res), 488)
  expect_equal(ncol(res), 8)

  res <- m4_outputevents(con, cohort = c(10246901, 10319938), itemlist = 226597)
  expect_equal(nrow(res), 27)
  expect_equal(ncol(res), 8)

  res <- m4_procedureevents(con, cohort = 12384098)
  expect_equal(nrow(res), 37)
  expect_equal(ncol(res), 26)

  res <- m4_procedureevents(con, cohort = c(13859862, 18917458, 19704964), itemlist = 225792)
  expect_equal(nrow(res), 3)
  expect_equal(ncol(res), 26)

  bigrquery::dbDisconnect(con)
})
