# These are the direct table access functions for the icu module tables
#
# In the m4_ base table and common pattern functions, the concept of a cohort is a group of subjects identified
# by numeric subject IDs.
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

#' Access charted items occurring during the ICU stay
#'
#' This function provides base access to the chartevents table containing data representing all the charted data
#' available for a patient. During their ICU stay, the primary repository of a patient’s information is their
#' electronic chart. The electronic chart displays patients' routine vital signs and any additional information
#' relevant to their care: ventilator settings, laboratory values, code status, mental status, and so on.
#' As a result, the bulk of information about a patient’s stay is contained in chartevents.
#'
#' Table attributes for chartevents table:
#'
#' (**PKEY** `subject_id`, `hadm_id`, `stay_id`)
#'
#' (**FKEY** `subject_id`) -> patients table
#'
#' (**FKEY** `hadm_id`) -> admissions table
#'
#' (**FKEY** `stay_id`) -> icustays table
#'
#' (**FKEY** `itemid`) -> d_items table, chartevents sub-table
#'
#' @param con A [bigrquery::bigquery()] DBIConnection object, as returned by [DBI::dbConnect()]
#' with an appropriate [bigrquery::bigquery()] DBI driver specified in the call.
#' @param cohort an optional vector of patient IDs defining the cohort of interest
#' @param itemlist an optional vector of item IDs defining the event types of interest
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
#' evt <- m4_chartevents(con, cohort = 12384098)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_chartevents <- function(con, cohort = NULL, itemlist = NULL, ...) {
  where <- combined_where(cohort, itemlist)

  m4_get_from_table(con, "chartevents", where) %>%
    dplyr::arrange(subject_id, charttime, hadm_id)
}

#' Access documented information which is in a date format (e.g. date of last dialysis)
#'
#' This function provides base access to the datetimeevents table containing data which represents all
#' date measurements about a patient in the ICU.
#'
#' For example, the date of last dialysis would be in the DATETIMEEVENTS table, but the systolic blood
#' pressure would not be in this table.
#'
#' Table attributes for datetimeevents table:
#'
#' (**PKEY** `subject_id`, `hadm_id`, `stay_id`)
#'
#' (**FKEY** `subject_id`) -> patients table
#'
#' (**FKEY** `hadm_id`) -> admissions table
#'
#' (**FKEY** `stay_id`) -> icustays table
#'
#' (**FKEY** `itemid`) -> d_items table, datetimeevents_items sub-table
#'
#' @inheritParams m4_chartevents
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
#' evt <- m4_datetimeevents(con, cohort = 15914798)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_datetimeevents <- function(con, cohort = NULL, itemlist = NULL, ...) {
  where <- combined_where(cohort, itemlist)

  m4_get_from_table(con, "datetimeevents", where) %>%
    dplyr::arrange(subject_id, charttime, hadm_id)
}

#' Access tracking information for ICU stays including admissions and discharge times
#'
#' This function provides base access to the icustays table containing data which represents the tracking
#' information for ICU stays including admissions and discharge times.
#'
#' Table attributes for icustays table:
#'
#' (**PKEY** `subject_id`, `hadm_id`, `stay_id`)
#'
#' (**FKEY** `subject_id`) -> patients table
#'
#' (**FKEY** `hadm_id`) -> admissions table
#'
#' @inheritParams m4_chartevents
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
#' stays <- m4_icustays(con, cohort = 12384098)
#' dim(stays)
#'
#' bigrquery::dbDisconnect(con)
m4_icustays <- function(con, cohort = NULL, ...) {
  where <- cohort_where(cohort)

  m4_get_from_table(con, "icustays", where) %>%
    dplyr::arrange(subject_id, intime, hadm_id)
}

#' Access information documented regarding continuous infusions or intermittent administrations
#'
#' This function provides base access to the inputevents table containing data representing all information
#' documented regarding continuous infusions or intermittent administrations.
#'
#' Table attributes for inputevents table:
#'
#' (**PKEY** `subject_id`, `hadm_id`, `stay_id`)
#'
#' (**FKEY** `subject_id`) -> patients table
#'
#' (**FKEY** `hadm_id`) -> admissions table
#'
#' (**FKEY** `stay_id`) -> icustays table
#'
#' (**FKEY** `itemid`) -> d_items table, inputevents_items sub-table
#'
#' @inheritParams m4_chartevents
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
#' evt <- m4_inputevents(con, cohort = 12384098)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_inputevents <- function(con, cohort = NULL, itemlist = NULL, ...) {
  where <- combined_where(cohort, itemlist)

  m4_get_from_table(con, "inputevents", where) %>%
    dplyr::arrange(subject_id, starttime, hadm_id)
}

#' Access information regarding patient outputs including urine, drainage, and so on
#'
#' This function provides base access to the outputevents table containing data representing all information
#' regarding patient outputs, for example, urine, drainage, etc.
#'
#' Table attributes for outputevents table:
#'
#' (**PKEY** `subject_id`, `hadm_id`, `stay_id`)
#'
#' (**FKEY** `subject_id`) -> patients table
#'
#' (**FKEY** `hadm_id`) -> admissions table
#'
#' (**FKEY** `stay_id`) -> icustays table
#'
#' (**FKEY** `itemid`) -> d_items table, outputevents_items sub-table
#'
#' @inheritParams m4_chartevents
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
#' evt <- m4_outputevents(con, cohort = 12384098)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_outputevents <- function(con, cohort = NULL, itemlist = NULL, ...) {
  where <- combined_where(cohort, itemlist)

  m4_get_from_table(con, "outputevents", where) %>%
    dplyr::arrange(subject_id, charttime, hadm_id)
}

#' Access procedures documented during the ICU stay
#'
#' This functions provides base access to the procedureevents table from the hospital ICU.
#' They include data on all procedures documented during the ICU stay (e.g. ventilation), though not
#' necessarily conducted within the ICU (e.g. x-ray imaging).
#'
#' Table attributes for procedureevents table:
#'
#' (**PKEY** `subject_id`, `hadm_id`, `stay_id`)
#'
#' (**FKEY** `subject_id`) -> patients table
#'
#' (**FKEY** `hadm_id`) -> admissions table
#'
#' (**FKEY** `stay_id`) -> icustays table
#'
#' (**FKEY** `itemid`) -> d_items table, procedureevents_items sub-table
#'
#' @inheritParams m4_chartevents
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
#' evt <- m4_procedureevents(con, cohort = 12384098)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_procedureevents <- function(con, cohort = NULL, itemlist = NULL, ...) {
  where <- combined_where(cohort, itemlist)

  m4_get_from_table(con, "procedureevents", where) %>%
    dplyr::arrange(subject_id, starttime, hadm_id)
}
