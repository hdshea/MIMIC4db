test_that("m4_core functions work", {
  con <- bigrquery::dbConnect(
    bigrquery::bigquery(),
    project = bigrquery::bq_test_project(),
    quiet = TRUE
  )

  pat <- m4_patients(con, cohort = c(10137012, 10660064))
  expect_equal(nrow(pat), 2)
  expect_equal(ncol(pat), 6)

  adm <- m4_admissions(con, cohort = c(10137012, 10660064))
  expect_equal(nrow(adm), 2)
  expect_equal(ncol(adm), 15)

  trn <- m4_transfers(con, cohort = c(10137012, 10660064))
  expect_equal(nrow(trn), 5)
  expect_equal(ncol(trn), 7)

  bigrquery::dbDisconnect(con)
})
