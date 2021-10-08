# These are the direct table access functions for the icu module tables
#
# In the m4_ base table and common pattern functions, the concept of a cohort is a group of subjects identified
# by numeric SUBJECT_IDs.
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
#' This table contains the majority of information documented in the ICU
#'
#' (PKEY `subject_id`, `hadm_id`, `stay_id`)
#'
#' @inheritParams m4_patients
#'
#' @returns a tibble with the results.
#' @export
#'
#' @examples
#' con <- bigrquery::dbConnect(
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#'
#' evt <- m4_chartevents(con, cohort = 12384098)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_chartevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("chartevents"), where) %>%
        dplyr::arrange(subject_id, charttime, hadm_id)
}

#' Access documented information which is in a date format (e.g. date of last dialysis)
#'
#' (PKEY `subject_id`, `hadm_id`, `stay_id`)
#'
#' @inheritParams m4_patients
#'
#' @returns a tibble with the results.
#' @export
#'
#' @examples
#' con <- bigrquery::dbConnect(
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#'
#' evt <- m4_datetimeevents(con, cohort = 12384098)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_datetimeevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("datetimeevents"), where) %>%
        dplyr::arrange(subject_id, charttime, hadm_id)
}

#' Access tracking information for ICU stays including adminission and discharge times
#'
#' (PKEY `subject_id`, `hadm_id`, `stay_id`)
#'
#' @inheritParams m4_patients
#'
#' @returns a tibble with the results.
#' @export
#'
#' @examples
#' con <- bigrquery::dbConnect(
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#'
#' stays <- m4_icustays(con, cohort = 12384098)
#' dim(stays)
#'
#' bigrquery::dbDisconnect(con)
m4_icustays <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("icustays"), where) %>%
        dplyr::arrange(subject_id, intime, hadm_id)
}

#' Access information documented regarding continuous infusions or intermittent administrations
#'
#' (PKEY `subject_id`, `hadm_id`, `stay_id`)
#'
#' @inheritParams m4_patients
#'
#' @returns a tibble with the results.
#' @export
#'
#' @examples
#' con <- bigrquery::dbConnect(
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#'
#' evt <- m4_inputevents(con, cohort = 12384098)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_inputevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("inputevents"), where) %>%
        dplyr::arrange(subject_id, starttime, hadm_id)
}

#' Access information regarding patient outputs including urine, drainage, and so on
#'
#' (PKEY `subject_id`, `hadm_id`, `stay_id`)
#'
#' @inheritParams m4_patients
#'
#' @returns a tibble with the results.
#' @export
#'
#' @examples
#' con <- bigrquery::dbConnect(
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#'
#' evt <- m4_outputevents(con, cohort = 12384098)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_outputevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("outputevents"), where) %>%
        dplyr::arrange(subject_id, charttime, hadm_id)
}

#' Access procedures documented during the ICU stay
#'
#' This functions provides base access to the procedureevents table from the hospital icu.
#' They include data on all procedures documented during the ICU stay (e.g. ventilation), though not
#' necessarily conducted within the ICU (e.g. x-ray imaging).
#'
#' (PKEY `subject_id`, `hadm_id`, `stay_id`)
#'
#' @inheritParams m4_patients
#'
#' @returns a tibble with the results.
#' @export
#'
#' @examples
#' con <- bigrquery::dbConnect(
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#'
#' evt <- m4_procedureevents(con, cohort = 12384098)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_procedureevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("procedureevents"), where) %>%
        dplyr::arrange(subject_id, starttime, hadm_id)
}
