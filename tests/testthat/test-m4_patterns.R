test_that("m4_patterns functions work", {
  con <- bigrquery::dbConnect(
    bigrquery::bigquery(),
    project = bigrquery::bq_test_project(),
    quiet = TRUE
  )

  patadm <- m4_patient_admissions(con, cohort = 16904137)
  expect_equal(nrow(patadm), 2)
  expect_equal(ncol(patadm), 19)

  icudet <- m4_patient_icustays(con, cohort = 16904137)
  expect_equal(nrow(icudet), 1)
  expect_equal(ncol(icudet), 25)

  bigrquery::dbDisconnect(con)
})
