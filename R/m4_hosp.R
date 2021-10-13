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

#' Access billed ICD-9/ICD-10 diagnoses for hospitalizations
#'
#' This function provides base access to the diagnoses_icd table containing data which represent a record of all
#' diagnoses a patient was billed for during their hospital stay using the ICD-9 and ICD-10 ontologies. Diagnoses
#' are billed on hospital discharge, and are determined by trained persons who read signed clinical notes.
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
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
#' )
#'
#' diag <- m4_diagnoses(con, cohort = 10137012)
#' dim(diag)
#'
#' bigrquery::dbDisconnect(con)
m4_diagnoses <- function(con, cohort = NULL, ...) {
  where <- cohort_where(cohort)

  m4_get_from_table(con, mimic4_table_name("diagnoses_icd"), where) %>%
    dplyr::left_join(m4_d_icd_diagnoses(con), by = c("icd_code", "icd_version")) %>%
    dplyr::mutate(diagnosis = long_title) %>%
    dplyr::select(-icd_code, -icd_version, -long_title) %>%
    dplyr::arrange(subject_id, hadm_id, seq_num)
}

#' Access billed DRG codes for hospitalizations
#'
#' This function provides base access to the drgcodes table containing data pertaining to diagnosis related groups
#' (DRGs) which are used by the hospital to obtain reimbursement for a patient’s hospital stay. The codes correspond
#' to the primary reason for a patient’s stay at the hospital.
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
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
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
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
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
#' This function provides base access to the emar_detail table containing data for each medicine administration
#' made in the EMAR table. Information includes the associated pharmacy order, the dose due, the dose given,
#' and many other parameters associated with the medical administration.
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
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
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
#' This function provides base access to the hcpcsevents table containing data about all billed events occurring
#' during the hospitalization.
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
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
#' )
#'
#' evt <- m4_hcpcsevents(con, cohort = 10137012)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_hcpcsevents <- function(con, cohort = NULL, ...) {
  where <- cohort_where(cohort)

  m4_get_from_table(con, mimic4_table_name("hcpcsevents"), where) %>%
    dplyr::select(-short_description) %>%
    dplyr::left_join(m4_d_hcpcs(con), by = c("hcpcs_cd" = "code")) %>%
    dplyr::mutate(code = hcpcs_cd) %>%
    dplyr::select(subject_id, hadm_id, chartdate, seq_num, code, category, long_description, short_description) %>%
    dplyr::arrange(subject_id, chartdate, hadm_id)
}

#' Access laboratory measurements sourced from patient derived specimens
#'
#' This function provides base access to the labevents table containing data pertaining to the results
#' of all laboratory measurements made for a single patient. These include hematology measurements,
#' blood gases, chemistry panels, and less common tests such as genetic assays.
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
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
#' )
#'
#' evt <- m4_labevents(con, cohort = 10137012)
#' dim(evt)
#'
#' bigrquery::dbDisconnect(con)
m4_labevents <- function(con, cohort = NULL, ...) {
  where <- cohort_where(cohort)

  m4_get_from_table(con, mimic4_table_name("labevents"), where) %>%
    dplyr::left_join(m4_d_labitems(con), by = "itemid") %>%
    dplyr::mutate(lab_item = label) %>%
    dplyr::select(
      labevent_id, subject_id, hadm_id, specimen_id, charttime, storetime,
      lab_item, fluid, category, value, valuenum, valueuom,
      ref_range_lower, ref_range_upper, flag, priority, comments, loinc_code
    ) %>%
    dplyr::arrange(subject_id, charttime, hadm_id)
}

#' Access microbiology cultures
#'
#' This function provides base access to the microbiologyevents table containing data on all microbiology tests
#' which are a common procedure to check for infectious growth and to assess which antibiotic treatments are
#' most effective.
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
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
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
#' This function provides base access to the pharmacy table containing data of detailed information regarding
#' filled medications which were prescribed to the patient. Pharmacy information includes the dose of the drug,
#' the number of formulary doses, the frequency of dosing, the medication route, and the duration of the
#' prescription.
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
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
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
#' This function provides base access to the poe table containing data pertaining to provider order entry (POE)
#' whcih is the general interface through which care providers at the hospital enter orders. Most treatments
#' and procedures must be ordered via POE.
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
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
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
#' This function provides base access to the poe_detail table containing data representing further information
#' on POE orders. The table uses an Entity-Attribute-Value (EAV) model: the entity is poe_id, the attribute is
#' field_name, and the value is field_value. EAV tables allow for flexible description of entities when the
#' attributes are heterogenous.
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
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
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
#' This function provides base access to the prescriptions table containing data about prescribed medications.
#' Information includes the name of the drug, coded identifiers including the Generic Sequence Number (GSN) and
#' National Drug Code (NDC), the product strength, the formulary dose, and the route of administration.
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
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
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
#' This function provides base access to the procedures_icd table containing data which represents a record of
#' all procedures a patient was billed for during their hospital stay using the ICD-9 and ICD-10 ontologies.
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
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
#' )
#'
#' icd <- m4_procedures(con, cohort = 10137012)
#' dim(icd)
#'
#' bigrquery::dbDisconnect(con)
m4_procedures <- function(con, cohort = NULL, ...) {
  where <- cohort_where(cohort)

  m4_get_from_table(con, mimic4_table_name("procedures_icd"), where) %>%
    dplyr::left_join(m4_d_icd_procedures(con), by = c("icd_code", "icd_version")) %>%
    dplyr::mutate(procedure = long_title) %>%
    dplyr::select(-icd_code, -icd_version, -long_title) %>%
    dplyr::arrange(subject_id, hadm_id, seq_num, chartdate)
}

#' Access the hospital service(s) which cared for the patient during their hospitalization
#'
#' This function provides base access to the services table containing data that describes the service under which
#' a patient was admitted.
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
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
#' )
#'
#' svs <- m4_services(con, cohort = 10137012)
#' dim(svs)
#'
#' bigrquery::dbDisconnect(con)
m4_services <- function(con, cohort = NULL, ...) {
  where <- cohort_where(cohort)
  svclkp <- m4_service_decsriptions()

  m4_get_from_table(con, mimic4_table_name("services"), where) %>%
    dplyr::arrange(subject_id, transfertime, hadm_id) %>%
    dplyr::group_by(subject_id, hadm_id) %>%
    dplyr::mutate(
      service_seq = dplyr::row_number(),
      first_service = (service_seq == 1)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::left_join(svclkp, by = c("curr_service" = "service")) %>%
    dplyr::mutate(curr_description = description, curr_short_desc = short_description) %>%
    dplyr::select(-description, -short_description) %>%
    dplyr::left_join(svclkp, by = c("prev_service" = "service")) %>%
    dplyr::mutate(prev_description = description, prev_short_desc = short_description) %>%
    dplyr::select(
      subject_id, hadm_id, transfertime, service_seq, first_service,
      curr_service, curr_short_desc, curr_description,
      prev_service, prev_short_desc, prev_description
    )
}
