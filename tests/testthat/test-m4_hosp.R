test_that("m4_hosp functions work", {
  con <- bigrquery::dbConnect(
    bigrquery::bigquery(),
    project = bigrquery::bq_test_project(),
    quiet = TRUE
  )

  res <- m4_diagnoses(con, cohort = 10047172)
  expect_equal(nrow(res), 98)
  expect_equal(ncol(res), 4)

  res <- m4_drgcodes(con, cohort = 10047172)
  expect_equal(nrow(res), 6)
  expect_equal(ncol(res), 7)

  res <- m4_emar(con, cohort = 10047172)
  expect_equal(nrow(res), 1029)
  expect_equal(ncol(res), 11)

  res <- m4_emar_detail(con, cohort = 10047172)
  expect_equal(nrow(res), 2011)
  expect_equal(ncol(res), 33)

  res <- m4_hcpcsevents(con, cohort = 10047172)
  expect_equal(nrow(res), 2)
  expect_equal(ncol(res), 8)

  res <- m4_labevents(con, cohort = 10047172)
  expect_equal(nrow(res), 2780)
  expect_equal(ncol(res), 18)

  res <- m4_microbiologyevents(con, cohort = 10047172)
  expect_equal(nrow(res), 42)
  expect_equal(ncol(res), 24)

  res <- m4_pharmacy(con, cohort = 10047172)
  expect_equal(nrow(res), 266)
  expect_equal(ncol(res), 27)

  res <- m4_poe(con, cohort = 10047172)
  expect_equal(nrow(res), 676)
  expect_equal(ncol(res), 11)

  res <- m4_poe_detail(con, cohort = 10047172)
  expect_equal(nrow(res), 62)
  expect_equal(ncol(res), 5)

  res <- m4_prescriptions(con, cohort = 10047172)
  expect_equal(nrow(res), 294)
  expect_equal(ncol(res), 17)

  res <- m4_procedures(con, cohort = 10047172)
  expect_equal(nrow(res), 14)
  expect_equal(ncol(res), 5)

  res <- m4_services(con, cohort = 10047172)
  expect_equal(nrow(res), 5)
  expect_equal(ncol(res), 11)

  bigrquery::dbDisconnect(con)
})
