test_that("m4_meta functions work", {
    dat <- m4_meta_data()
    expect_equal(nrow(dat), 27)
    expect_equal(ncol(dat), 3)

    dat <- m4_service_decsriptions()
    expect_equal(nrow(dat), 20)
    expect_equal(ncol(dat), 3)
})
