test_that("m4_icu functions work", {
    con <- bigrquery::dbConnect(
        bigrquery::bigquery(),
        project = bigrquery::bq_test_project(),
        quiet = TRUE
    )

    res <- m4_chartevents(con, cohort = 12384098)
    expect_equal(nrow(res), 30036)
    expect_equal(ncol(res), 10)

    res <- m4_datetimeevents(con, cohort = 12384098)
    expect_equal(nrow(res), 940)
    expect_equal(ncol(res), 9)

    res <- m4_icustays(con, cohort = 12384098)
    expect_equal(nrow(res), 1)
    expect_equal(ncol(res), 8)

    res <- m4_inputevents(con, cohort = 12384098)
    expect_equal(nrow(res), 1274)
    expect_equal(ncol(res), 26)

    res <- m4_outputevents(con, cohort = 12384098)
    expect_equal(nrow(res), 488)
    expect_equal(ncol(res), 8)

    res <- m4_procedureevents(con, cohort = 12384098)
    expect_equal(nrow(res), 37)
    expect_equal(ncol(res), 26)

    bigrquery::dbDisconnect(con)
})
