#' Encapsulated meta data for MIMIC IV tables
#'
#' The function returns a tibble with the table name, MIMIC module and a description (all provided from the
#' [MIMIC-IV website](https://mimic.mit.edu/docs/iv/)).
#'
#' @return a tibble containing meta data concerning MIMIC IV tables.
#' @export
#'
#' @examples
#' core <- m4_meta_data() %>%
#'     dplyr::filter(module == "mimic_core") %>%
#'     dplyr::transmute(statement = stringr::str_c("select * from physionet-data.", module, ".", table))
#' core
m4_meta_data <- function() {
    tibble::tribble(
        ~table, ~module, ~description,
        "admissions", "mimic_core", "The admissions table defines all hospitalizations in the database. Hospitalizations are assigned a unique random integer known as the hadm_id.",
        "patients", "mimic_core", "Information that is consistent for the lifetime of a patient is stored in this table.",
        "transfers", "mimic_core", "Physical locations for patients throughout their hospital stay.",
        "d_hcpcs", "mimic_hosp", "Dimension table for hcpcsevents; provides a description of CPT codes.",
        "d_icd_diagnoses", "mimic_hosp", "Dimension table for diagnoses_icd; provides a description of ICD-9/ICD-10 billed diagnoses.",
        "d_icd_procedures", "mimic_hosp", "Dimension table for procedures_icd; provides a description of ICD-9/ICD-10 billed procedures.",
        "d_labitems", "mimic_hosp", "Dimension table for labevents; provides a description of all lab items.",
        "diagnoses_icd", "mimic_hosp", "Billed ICD-9/ICD-10 diagnoses for hospitalizations.",
        "drgcodes", "mimic_hosp", "Billed DRG codes for hospitalizations.",
        "emar", "mimic_hosp", "The Electronic Medicine Administration Record (eMAR); barcode scanning of medications at the time of administration.",
        "emar_detail", "mimic_hosp", "Supplementary information for electronic administrations recorded in emar.",
        "hcpcsevents", "mimic_hosp", "Billed events occurring during the hospitalization. Includes CPT codes.",
        "labevents", "mimic_hosp", "Laboratory measurements sourced from patient derived specimens.",
        "microbiologyevents", "mimic_hosp", "Microbiology cultures.",
        "pharmacy", "mimic_hosp", "Formulary, dosing, and other information for prescribed medications.",
        "poe", "mimic_hosp", "Orders made by providers relating to patient care.",
        "poe_detail", "mimic_hosp", "Supplementary information for orders made by providers in the hospital.",
        "prescriptions", "mimic_hosp", "Prescribed medications.",
        "procedures_icd", "mimic_hosp", "Billed procedures for patients during their hospital stay.",
        "services", "mimic_hosp", "The hospital service(s) which cared for the patient during their hospitalization.",
        "d_items", "mimic_icu", "Dimension table describing itemid. Defines concepts recorded in the events table in the ICU module.",
        "chartevents", "mimic_icu", "Charted items occurring during the ICU stay. Contains the majority of information documented in the ICU.",
        "datetimeevents", "mimic_icu", "Documented information which is in a date format (e.g. date of last dialysis).",
        "icustays", "mimic_icu", "Tracking information for ICU stays including adminission and discharge times.",
        "inputevents", "mimic_icu", "Information documented regarding continuous infusions or intermittent administrations.",
        "outputevents", "mimic_icu", "Information regarding patient outputs including urine, drainage, and so on.",
        "procedureevents", "mimic_icu", "Procedures documented during the ICU stay (e.g. ventilation), though not necessarily conducted within the ICU (e.g. x-ray imaging)."
    )
}

#' Encapsulated descriptive data for services
#'
#' The function returns a tibble with descriptive data from services including service code, detailed description and
#' short description.
#'
#' @return a tibble containing descriptive data for services.
#' @export
#'
#' @examples
#' neuro <- m4_service_decsriptions() %>%
#'     dplyr::filter(startsWith(short_description, "Neurologic")) %>%
#'     dplyr::select(service, short_description)
#' neuro
m4_service_decsriptions <- function() {
    tibble::tribble(
        ~service, ~description,
        "CMED", "Cardiac Medical - for non-surgical cardiac related admissions",
        "CSURG", "Cardiac Surgery - for surgical cardiac admissions",
        "DENT", "Dental - for dental/jaw related admissions",
        "ENT", "Ear, nose, and throat - conditions primarily affecting these areas",
        "GU", "Genitourinary - reproductive organs/urinary system",
        "GYN", "Gynecological - female reproductive systems and breasts",
        "MED", "Medical - general service for internal medicine",
        "NB", "Newborn - infants born at the hospital",
        "NBB", "Newborn baby - infants born at the hospital",
        "NMED", "Neurologic Medical - non-surgical, relating to the brain",
        "NSURG", "Neurologic Surgical - surgical, relating to the brain",
        "OBS", "Obstetrics - conerned with childbirth and the care of women giving birth",
        "ORTHO", "Orthopaedic - surgical, relating to the musculoskeletal system",
        "OMED", "Orthopaedic medicine - non-surgical, relating to musculoskeletal system",
        "PSURG", "Plastic - restortation/reconstruction of the human body (including cosmetic or aesthetic)",
        "PSYCH", "Psychiatric - mental disorders relating to mood, behaviour, cognition, or perceptions",
        "SURG", "Surgical - general surgical service not classified elsewhere",
        "TRAUM", "Trauma - injury or damage caused by physical harm from an external source",
        "TSURG", "Thoracic Surgical - surgery on the thorax, located between the neck and the abdomen",
        "VSURG", "Vascular Surgical - surgery relating to the circulatory system"
    ) %>%
    dplyr::mutate(short_description = stringr::str_split(description, " - ", simplify = TRUE)[, 1])
}
