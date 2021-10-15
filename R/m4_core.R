# These are the direct table access functions for the core module tables
#
# In the m4_ base table and common pattern functions, the concept of a cohort is a group of subjects identified
# by numeric subject IDs
#
# A cohort can be:
#
# * NULL, indicating the entire MIMIC-IV population
# * a single SUBJECT_ID for an indivdual, or
# * a vector of SUBJECT_IDs for a proper subset of the entire population.
#
# In the m4_ base table and common pattern functions, the concept of an item list is a group of event items
# identified by numeric ITEMIDs.
#
# A item list can be:
#
# * NULL, indicating the every item
# * a single ITEMID for an individual ITEMID, or
# * a list of ITEMIDs for a proper subset of the eveny items.
#' @include internals.R
NULL

#' Access unique patients in the database
#'
#' This function provides base access to the patients table containing data that is consistent for the
#' time span of a patient in the database - i.e., there is one unique entry per patient in the database.
#'
#' Table attributes for patients table:
#'
#' (**PKEY** `subject_id`)
#'
#' @param con A [bigrquery::bigquery()] DBIConnection object, as returned by [DBI::dbConnect()]
#' with an appropriate [bigrquery::bigquery()] DBI driver specified in the call.
#' @param cohort an optional vector of patient IDs defining the cohort of interest
#' @param ... additional optional passed along parameters.
#'
#' @returns a tibble with the results.
#' @export
#'
#' @examples
#' # To run examples, you must have the BIGQUERY_TEST_PROJECT environment
#' # variable set to name of project which has billing set up and to which
#' # you have write access.
#' con <- bigrquery::dbConnect(
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
#' )
#'
#' pat <- m4_patients(con, cohort = 10137012)
#' dim(pat)
#'
#' bigrquery::dbDisconnect(con)
m4_patients <- function(con, cohort = NULL, ...) {
  where <- cohort_where(cohort)

  m4_get_from_table(con, "patients", where) %>%
    dplyr::arrange(subject_id)
}

#' Access unique hospitalizations for patients in the database
#'
#' This function provides base access to the admissions table containing information regarding a patient’s
#' admission to the hospital. Since each unique hospital visit for a patient is assigned a unique `hadm_id`,
#' the admissions table can be considered as a definition table for `hadm_id`. Information available includes
#' timing information for admission and discharge, demographic information, the source of the admission, and so on.
#'
#' Table attributes for admissions table:
#'
#' (**PKEY** `hadm_id`)
#'
#' (**FKEY** `subject_id`) -> patients table
#'
#' @inheritParams m4_patients
#'
#' @returns a tibble with the results.
#' @export
#'
#' @examples
#' # To run examples, you must have the BIGQUERY_TEST_PROJECT environment
#' # variable set to name of project which has billing set up and to which
#' # you have write access.
#' con <- bigrquery::dbConnect(
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
#' )
#'
#' adm <- m4_admissions(con, cohort = 10137012)
#' dim(adm)
#'
#' bigrquery::dbDisconnect(con)
m4_admissions <- function(con, cohort = NULL, ...) {
  where <- cohort_where(cohort)

  m4_get_from_table(con, "admissions", where) %>%
    dplyr::arrange(subject_id, admittime, hadm_id)
}

#' Access patient movement from bed to bed within the hospital, including ICU admission and discharge
#'
#' This function provides base access to the transfers table containing information about the physical locations
#' for patients throughout their hospital stay.
#'
#' Table attributes for transfers table:
#'
#' (**PKEY** `subject_id`, `hadm_id`, `transfer_id`)
#'
#' (**FKEY** `subject_id`) -> patients table
#'
#' (**FKEY** `hadm_id`) -> admissions table
#'
#'
#' @inheritParams m4_patients
#'
#' @returns a tibble with the results.
#' @export
#'
#' @examples
#' # To run examples, you must have the BIGQUERY_TEST_PROJECT environment
#' # variable set to name of project which has billing set up and to which
#' # you have write access.
#' con <- bigrquery::dbConnect(
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
#' )
#'
#' trn <- m4_transfers(con, cohort = 10137012)
#' dim(trn)
#'
#' bigrquery::dbDisconnect(con)
m4_transfers <- function(con, cohort = NULL, ...) {
  where <- cohort_where(cohort)

  m4_get_from_table(con, "transfers", where) %>%
    dplyr::arrange(subject_id, intime, hadm_id)
}
