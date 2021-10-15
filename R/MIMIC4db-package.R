#' @description
#' MIMIC4db provides a tightly bound set of routines to reference the Google BigQuery version of
#' the [MIMIC-IV v1.0](https://physionet.org/content/mimiciii/1.0/) database using base access
#' routines from the [DBI](https://github.com/r-dbi/DBI) R package and the
#' [bigrquery](https://github.com/r-dbi/bigrquery) R package.
#'
#' @importFrom magrittr %>%
"_PACKAGE"

# hack for handling peculiarity of using dplyr and unquoted variable names inside a package
admittime <- chartdate <- charttime <- code <- description <- emar_id <- emar_seq <- NULL
hadm_id <- icd_code <- icd_version <- intime <- itemid <- linksto <- module <- ordertime <- NULL
parent_field_ordinal <- poe_seq <- seq_num <- starttime <- statement <- subject_id <- NULL
transfertime <- admission_age <- admission_decade <- admission_location <- admission_seq <- NULL
admission_type <- anchor_age <- discharge_location <- dischtime <- dod <- NULL
ethnicity_group <- first_admission <- first_icustay <- gender <- icustay_seq <- NULL
insurance <- los <- los_hospital <- los_icustay <- outtime <- stay_id <- NULL
anchor_year_group <- langauge <- marital_status <- anchor_year <- NULL
category <- comments <- curr_description <- curr_service <- curr_short_desc <- NULL
first_service <- flag <- fluid <- hcpcs_cd <- lab_item <- label <- labevent_id <- language <- NULL
loinc_code <- long_description <- long_title <- prev_description <- prev_service <- NULL
prev_short_desc <- priority <- ref_range_lower <- ref_range_upper <- service_seq <- NULL
short_description <- specimen_id <- storetime <- value <- valuenum <- valueuom <- NULL
