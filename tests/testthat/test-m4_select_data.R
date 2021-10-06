test_that("m4_select_data works", {
    con <- bigrquery::dbConnect(
        bigrquery::bigquery(),
        project = bigrquery::bq_test_project(),
        quiet = TRUE
    )

    dat <- m4_select_data(con, "select * from physionet-data.mimic_icu.d_items limit 5")
    expect_equal(2 * 2, 4)

    bigrquery::dbDisconnect(con)
})
