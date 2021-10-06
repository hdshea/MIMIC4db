test_that("m4_select_data works", {
    con <- bigrquery::dbConnect(
        bigrquery::bigquery(),
        project = bigrquery::bq_test_project(),
        quiet = TRUE
    )

    dat <- m4_select_data(con, "select * from physionet-data.mimic_icu.d_items order by itemid limit 5") %>%
        dplyr::arrange(itemid)
    expect_equal(hds_t_dat, dat)

    bigrquery::dbDisconnect(con)
})
