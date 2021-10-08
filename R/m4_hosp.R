#' Access billed ICD-9/ICD-10 diagnoses for hospitalizations
#'
#' (PKEY `subject_id`, `hadm_id`, `seq_num`)
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
#' diag <- m4_diagnoses_icd(con, cohort = 10137012)
#' dim(diag)
#'
#' bigrquery::dbDisconnect(con)
m4_diagnoses_icd <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("diagnoses_icd"), where) %>%
        dplyr::arrange(subject_id, hadm_id, seq_num)
}

#' Access billed DRG codes for hospitalizations
#'
#' (PKEY `subject_id`, `hadm_id`)
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
#' drgc <- m4_drgcodes(con, cohort = 10137012)
#' dim(drgc)
#'
#' bigrquery::dbDisconnect(con)
m4_drgcodes <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("drgcodes"), where) %>%
        dplyr::arrange(subject_id, hadm_id)
}

#' Access Electronic Medicine Administration Records (eMAR)
#'
#' This functions provides base access to the emar table from the hospital module.  These data are
#' collected by barcode scanning of medications at the time of administration.
#'
#' (PKEY `subject_id`, `hadm_id`, `emar_id`, `emar_seq`)
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
#' emar <- m4_emar(con, cohort = 10137012)
#' dim(emar)
#'
#' bigrquery::dbDisconnect(con)
m4_emar <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("emar"), where) %>%
        dplyr::arrange(subject_id, hadm_id, emar_id, emar_seq)
}

#' Access supplementary information for electronic administrations recorded in emar
#'
#' (PKEY `subject_id`, `emar_id`, `emar_seq`, `parent_field_ordinal`)
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
#' edet <- m4_emar_detail(con, cohort = 10137012)
#' dim(edet)
#'
#' bigrquery::dbDisconnect(con)
m4_emar_detail <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("emar_detail"), where) %>%
        dplyr::arrange(subject_id, emar_id, emar_seq, parent_field_ordinal)
}

#' Access billed events occurring during the hospitalization; includes CPT codes
#'
#' (PKEY `subject_id`, `hadm_id`)
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
#' evt <- m4_hcpcsevents(con, cohort = 10137012)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_hcpcsevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("hcpcsevents"), where) %>%
        dplyr::arrange(subject_id, chartdate, hadm_id)
}

#' Access laboratory measurements sourced from patient derived specimens
#'
#' (PKEY `labevent_id`)
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
#' evt <- m4_labevents(con, cohort = 10137012)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_labevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("labevents"), where) %>%
        dplyr::arrange(subject_id, charttime, hadm_id)
}

#' Access microbiology cultures
#'
#' (PKEY `microevent_id`)
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
#' evt <- m4_microbiologyevents(con, cohort = 10137012)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_microbiologyevents <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("microbiologyevents"), where) %>%
        dplyr::arrange(subject_id, charttime, hadm_id)
}

#' Access formulary, dosing, and other information for prescribed medications
#'
#' (PKEY `subject_id`, `hadm_id`. `pharmacy_id`)
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
#' evt <- m4_pharmacy(con, cohort = 10137012)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_pharmacy <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("pharmacy"), where) %>%
        dplyr::arrange(subject_id, starttime, hadm_id)
}

#' Access orders made by providers relating to patient care
#'
#' (PKEY `subject_id`, `hadm_id`. `poe_seq`)
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
#' poe <- m4_poe(con, cohort = 10137012)
#' dim(poe)
#'
#' bigrquery::dbDisconnect(con)
m4_poe <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("poe"), where) %>%
        dplyr::arrange(subject_id, ordertime, hadm_id, poe_seq)
}

#' Access supplementary information for orders made by providers in the hospital
#'
#' (PKEY `subject_id`, `hadm_id`. `poe_seq`)
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
#' pod <- m4_poe_detail(con, cohort = 10137012)
#' dim(pod)
#'
#' bigrquery::dbDisconnect(con)
m4_poe_detail <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("poe_detail"), where) %>%
        dplyr::arrange(subject_id, poe_seq)
}

#' Access prescribed medications
#'
#' (PKEY `subject_id`, `hadm_id`. `pharmacy_id`)
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
#' script <- m4_prescriptions(con, cohort = 10137012)
#' dim(script)
#'
#' bigrquery::dbDisconnect(con)
m4_prescriptions <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("prescriptions"), where) %>%
        dplyr::arrange(subject_id, starttime, hadm_id)
}

#' Access billed procedures for patients during their hospital stay
#'
#' (PKEY `subject_id`, `hadm_id`. `pharmacy_id`)
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
#' icd <- m4_procedures_icd(con, cohort = 10137012)
#' dim(icd)
#'
#' bigrquery::dbDisconnect(con)
m4_procedures_icd <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("procedures_icd"), where) %>%
        dplyr::arrange(subject_id, chartdate, hadm_id)
}

#' Access the hospital service(s) which cared for the patient during their hospitalization
#'
#' (PKEY `subject_id`, `hadm_id`. `pharmacy_id`)
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
#' svs <- m4_services(con, cohort = 10137012)
#' dim(svs)
#'
#' bigrquery::dbDisconnect(con)
m4_services <- function(con, cohort = NULL, ...) {
    where <- cohort_where(cohort)

    m4_get_from_table(con, mimic4_table_name("services"), where) %>%
        dplyr::arrange(subject_id, transfertime, hadm_id)
}
