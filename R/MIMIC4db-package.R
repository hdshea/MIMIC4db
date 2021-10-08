#' @description
#' MIMIC4db provides a tightly bound set of routines to reference the Google BigQuery version of
#' the [MIMIC-IV v1.0](https://physionet.org/content/mimiciii/1.0/) database using base access
#' routines from the [DBI](https://github.com/r-dbi/DBI) R package with an appropriate
#' [bigrquery](https://github.com/r-dbi/bigrquery) DBIConnection.
#'
#' @importFrom magrittr %>%
"_PACKAGE"

# hack for handling peculiarity of using dplyr and unquoted variable names inside a package
admittime <- chartdate <- charttime <- code <- description <- emar_id <- emar_seq <- NULL
hadm_id <- icd_code <- icd_version <- intime <- itemid <- linksto <- module <- ordertime <- NULL
parent_field_ordinal <- poe_seq <- seq_num <- starttime <- statement <- subject_id <- NULL
transfertime <- NULL
