test_that("m4_get_from_table works", {
    con <- bigrquery::dbConnect(
        bigrquery::bigquery(),
        project = bigrquery::bq_test_project(),
        quiet = TRUE
    )

    dat <- m4_get_from_table(con, "physionet-data.mimic_icu.d_items", where = "where itemid <= 220048")
    expect_equal(nrow(dat), 5)
    expect_equal(ncol(dat), 9)

    bigrquery::dbDisconnect(con)
})
