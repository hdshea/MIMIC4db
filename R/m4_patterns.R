# These are the direct table access functions for the core module tables
#
# In the m4_ base table and common pattern functions, the concept of a cohort is a group of subjects identified
# by numeric subject IDs
#
# A cohort can be:
#
# * NULL, indicating the entire MIMIC-IV population
# * a single subject_id for an indivdual, or
# * a vector of subject_ids for a proper subset of the entire population.
#
# In the m4_ base table and common pattern functions, the concept of an item list is a group of event items
# identified by numeric itemids.
#
# A item list can be:
#
# * NULL, indicating the every item
# * a single itemid for an individual itemid, or
# * a list of itemids for a proper subset of the eveny items.
#' @include internals.R
NULL

# ### Common Pattern Functions
#
# These functions return data frames representing common patterns of data access for research.
#

#' Access combined patient and admissions data.
#'
#' This function combines data from the patients with matching data from the admissions table.  The function
#' calculates additional common pattern data like length of stay in the hospital in days (`los_hospital`) and
#' age at admission in years (`admission_age`).  Patients who are older than 89 years old at any time in the
#' database have had their date of birth shifted to obscure their age and comply with HIPAA.  These ages
#' appear in the data as = 91.  As such, an additional field is added to categorize age into decades
#' (`admission_decade`).  Patients older than 89 show up in the 90 and older age decade bucket.
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
#' patadm <- m4_patient_admissions(con, cohort = 16904137)
#' dim(patadm)
#'
#' bigrquery::dbDisconnect(con)
m4_patient_admissions <- function(con, cohort = NULL, ...) {
  m4_admissions(con, cohort) %>%
    dplyr::left_join(m4_patients(con, cohort), by = "subject_id") %>%
    dplyr::mutate(
      los_hospital = lubridate::time_length(difftime(dischtime, admittime), "days"),
      admission_age =
        round(
          lubridate::time_length(
            difftime(admittime, ISOdate(anchor_year, 1, 1, 0, 0, 0)),
            "years"
          ) +
            anchor_age,
          2
        ),
      admission_decade = Hmisc::cut2(admission_age, c(0, 10, 20, 30, 40, 50, 60, 70, 80, 90)),
      ethnicity_group =
        dplyr::case_when(
          stringr::str_starts(ethnicity, "WHITE") ~ "WHITE",
          stringr::str_starts(ethnicity, "BLACK") ~ "BLACK",
          stringr::str_starts(ethnicity, "CARIBBEAN") ~ "BLACK",
          stringr::str_starts(ethnicity, "HISPANIC") ~ "HISPANIC",
          stringr::str_starts(ethnicity, "ASIAN") ~ "ASIAN",
          stringr::str_starts(ethnicity, "AMERICAN INDIAN") ~ "NATIVE",
          stringr::str_starts(ethnicity, "UNKNOWN") ~ "UNKNOWN",
          stringr::str_starts(ethnicity, "UNABLE") ~ "UNKNOWN",
          stringr::str_starts(ethnicity, "PATIENT") ~ "UNKNOWN",
          TRUE ~ "OTHER"
        ),
      ethnicity_group = as.factor(ethnicity_group),
      admission_type = as.factor(admission_type),
      admission_location = as.factor(admission_location),
      discharge_location = as.factor(discharge_location),
      insurance = as.factor(insurance),
      language = as.factor(language),
      marital_status = as.factor(marital_status)
    ) %>%
    dplyr::arrange(subject_id, admittime) %>%
    dplyr::group_by(subject_id) %>%
    dplyr::mutate(
      admission_seq = dplyr::row_number(),
      first_admission = (admission_seq == 1)
    ) %>%
    dplyr::ungroup() %>%
    dplyr::select(
      subject_id, hadm_id,
      gender, dod,
      admission_seq, first_admission, admittime, dischtime, los_hospital,
      admission_age, admission_decade, anchor_year_group,
      admission_type, admission_location, discharge_location,
      insurance, ethnicity_group, language, marital_status
    )
}

#' Access combined patient, admission and icu stay data.
#'
#' This includes all of the information from the `mimic_get_patient_admissions` function plus additional
#' data pertaining to individual ICU stays while in the hospital.
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
#' icudet <- m4_patient_icustays(con, cohort = 16904137)
#' dim(icudet)
#'
#' bigrquery::dbDisconnect(con)
m4_patient_icustays <- function(con, cohort = NULL, ...) {
  m4_icustays(con, cohort) %>%
    dplyr::full_join(m4_patient_admissions(con, cohort), by = c("subject_id", "hadm_id")) %>%
    dplyr::arrange(subject_id, admittime, intime) %>%
    dplyr::group_by(subject_id, hadm_id) %>%
    dplyr::mutate(
      icustay_seq = dplyr::row_number(),
      first_icustay = (icustay_seq == 1),
      los_icustay = los
    ) %>%
    dplyr::ungroup() %>%
    dplyr::select(
      subject_id, hadm_id, stay_id,
      gender, dod,
      admission_seq, first_admission, admittime, dischtime, los_hospital,
      admission_age, admission_decade, anchor_year_group,
      admission_type, admission_location, discharge_location,
      insurance, ethnicity_group, language, marital_status,
      icustay_seq, first_icustay, intime, outtime, los_icustay
    )
}
