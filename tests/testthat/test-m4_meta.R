test_that("m4_meta functions work", {
  dat <- m4_meta_data()
  expect_equal(nrow(dat), 27)
  expect_equal(ncol(dat), 3)

  dat <- m4_service_decsriptions()
  expect_equal(nrow(dat), 20)
  expect_equal(ncol(dat), 3)

  ex1 <- get_category("inputevents", "NotAValidCategory")
  ex2 <- get_category("chartevents", "general")
  ex3 <- get_category("chartevents", "Nutrition - Enteral")

  expect_equal(ex1, character()) # no match
  expect_equal(ex2, "General") # non-specific match
  expect_equal(ex3, "Nutrition - Enteral") # specific match
})
