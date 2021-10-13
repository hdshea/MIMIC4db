test_that("internal functions work", {
  tnm <- mimic4_table_name("patients")
  expect_equal(tnm, "physionet-data.mimic_core.patients")

  ex1 <- cohort_where(NULL)
  ex2 <- cohort_where(1)
  ex3 <- cohort_where(c(1:5))

  expect_null(ex1)
  expect_equal(ex2, "WHERE subject_id = 1")
  expect_equal(ex3, "WHERE subject_id IN (1, 2, 3, 4, 5)")

  ex1 <- itemlist_where(NULL)
  ex2 <- itemlist_where(1)
  ex3 <- itemlist_where(c(1:5))

  expect_null(ex1)
  expect_equal(ex2, "WHERE itemid = 1")
  expect_equal(ex3, "WHERE itemid IN (1, 2, 3, 4, 5)")

  ex1 <- combined_where(NULL)
  ex2 <- combined_where(1)
  ex3 <- combined_where(c(1:5))
  ex4 <- combined_where(1, 1)
  ex5 <- combined_where(c(1:5), c(1:5))

  expect_null(ex1)
  expect_equal(ex2, "WHERE subject_id = 1")
  expect_equal(ex3, "WHERE subject_id IN (1, 2, 3, 4, 5)")
  expect_equal(ex4, "WHERE subject_id = 1 AND itemid = 1")
  expect_equal(ex5, "WHERE subject_id IN (1, 2, 3, 4, 5) AND itemid IN (1, 2, 3, 4, 5)")
})
