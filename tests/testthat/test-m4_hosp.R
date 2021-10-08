test_that("m4_hosp functions work", {
    con <- bigrquery::dbConnect(
        bigrquery::bigquery(),
        project = bigrquery::bq_test_project(),
        quiet = TRUE
    )

    res <- m4_diagnoses_icd(con, cohort = 10137012)
    expect_equal(nrow(res), 3)
    expect_equal(ncol(res), 5)

    res <- m4_drgcodes(con, cohort = 10137012)
    expect_equal(nrow(res), 2)
    expect_equal(ncol(res), 7)

    res <- m4_emar(con, cohort = 10137012)
    expect_equal(nrow(res), 0)
    expect_equal(ncol(res), 11)

    res <- m4_emar_detail(con, cohort = 10137012)
    expect_equal(nrow(res), 0)
    expect_equal(ncol(res), 33)

    res <- m4_hcpcsevents(con, cohort = 10137012)
    expect_equal(nrow(res), 0)
    expect_equal(ncol(res), 6)

    res <- m4_labevents(con, cohort = 10137012)
    expect_equal(nrow(res), 3)
    expect_equal(ncol(res), 15)

    res <- m4_microbiologyevents(con, cohort = 10137012)
    expect_equal(nrow(res), 2)
    expect_equal(ncol(res), 24)

    res <- m4_pharmacy(con, cohort = 10137012)
    expect_equal(nrow(res), 5)
    expect_equal(ncol(res), 27)

    res <- m4_poe(con, cohort = 10137012)
    expect_equal(nrow(res), 0)
    expect_equal(ncol(res), 11)

    res <- m4_poe_detail(con, cohort = 10137012)
    expect_equal(nrow(res), 0)
    expect_equal(ncol(res), 5)

    res <- m4_prescriptions(con, cohort = 10137012)
    expect_equal(nrow(res), 5)
    expect_equal(ncol(res), 17)

    res <- m4_procedures_icd(con, cohort = 10137012)
    expect_equal(nrow(res), 0)
    expect_equal(ncol(res), 6)

    res <- m4_services(con, cohort = 10137012)
    expect_equal(nrow(res), 1)
    expect_equal(ncol(res), 5)

    bigrquery::dbDisconnect(con)
})
