test_that("m4_dimensions functions work", {
    con <- bigrquery::dbConnect(
        bigrquery::bigquery(),
        project = bigrquery::bq_test_project(),
        quiet = TRUE
    )

    tab <- m4_d_items(con)
    expect_equal(ncol(tab), 9)
    expect_equal(nrow(tab), 3861)

    tab <- m4_chartevents_items(con)
    expect_equal(ncol(tab), 8)
    expect_equal(nrow(tab), 2954)

    tab <- m4_datetimeevents_items(con)
    expect_equal(ncol(tab), 8)
    expect_equal(nrow(tab), 188)

    tab <- m4_inputevents_items(con)
    expect_equal(ncol(tab), 8)
    expect_equal(nrow(tab), 474)

    tab <- m4_outputevents_items(con)
    expect_equal(ncol(tab), 8)
    expect_equal(nrow(tab), 76)

    tab <- m4_procedureevents_items(con)
    expect_equal(ncol(tab), 8)
    expect_equal(nrow(tab), 169)

    tab <- m4_d_hcpcs(con)
    expect_equal(ncol(tab), 4)
    expect_equal(nrow(tab), 89200)

    tab <- m4_d_icd_diagnoses(con)
    expect_equal(ncol(tab), 3)
    expect_equal(nrow(tab), 109775)

    tab <- m4_d_icd_procedures(con)
    expect_equal(ncol(tab), 3)
    expect_equal(nrow(tab), 85257)

    tab <- m4_d_labitems(con)
    expect_equal(ncol(tab), 5)
    expect_equal(nrow(tab), 1630)

    bigrquery::dbDisconnect(con)
})
