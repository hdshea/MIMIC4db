test_that("m4_get_from_table works", {
    con <- bigrquery::dbConnect(
        bigrquery::bigquery(),
        project = bigrquery::bq_test_project(),
        quiet = TRUE
    )

    dat <- m4_get_from_table(con, "physionet-data.mimic_icu.d_items", where = "where itemid <= 223938")
    expect_equal(2 * 2, 4)

    bigrquery::dbDisconnect(con)
})
