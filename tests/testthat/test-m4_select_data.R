test_that("m4_select_data works", {
  con <- bigrquery::dbConnect(
    bigrquery::bigquery(),
    project = bigrquery::bq_test_project(),
    quiet = TRUE
  )

  dat <- m4_select_data(con, "select * from physionet-data.mimic_icu.d_items order by itemid limit 5")
  expect_equal(nrow(dat), 5)
  expect_equal(ncol(dat), 9)

  bigrquery::dbDisconnect(con)
})
