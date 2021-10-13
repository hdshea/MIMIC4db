#' Access dimension table describing itemid
#'
#' This function provides base access to the d_items table which defines concepts recorded in the events table in
#' the icu module.
#'
#' (PKEY `itemid`)
#'
#' @param con A [bigrquery::bigquery()] DBIConnection object, as returned by [DBI::dbConnect()]
#' with an appropriate [bigrquery::bigquery()] DBI driver specified in the call.
#' @param ... additional optional passed along parameters.
#'
#' @returns a tibble with the results.
#' @export
#' @examples
#' con <- bigrquery::dbConnect(
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
#' )
#'
#' tab <- m4_d_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_d_items <- function(con, ...) {
  m4_get_from_table(con, mimic4_table_name("d_items"), ...) %>%
    dplyr::arrange(linksto, itemid)
}

#' Access chartevents items reference
#'
#' This function provides base access to the d_items table which defines concepts recorded in the chartevents table in
#' the icu module.
#'
#' (PKEY `ITEMID`)
#'
#' @param con A [bigrquery::bigquery()] DBIConnection object, as returned by [DBI::dbConnect()]
#' with an appropriate [bigrquery::bigquery()] DBI driver specified in the call.
#' @param category an character string defining the item category of interest
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
#' tab <- m4_chartevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_chartevents_items <- function(con, category = character()) {
  where <- "where linksto = 'chartevents'"
  if (length(category) != 0) {
    category <- get_category("chartevents", category)
    where <- stringr::str_c(where, " and category = '", category, "'", sep = "")
  }

  m4_d_items(con, where = where) %>%
    dplyr::select(-linksto) %>%
    dplyr::arrange(category, itemid)
}

#' Access datetimeevents items reference
#'
#' This function provides base access to the d_items table which defines concepts recorded in the datetimeevents
#' table in the icu module.
#'
#' (PKEY `ITEMID`)
#'
#' @inheritParams m4_chartevents_items
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
#' tab <- m4_datetimeevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_datetimeevents_items <- function(con, category = character()) {
  where <- "where linksto = 'datetimeevents'"
  if (length(category) != 0) {
    category <- get_category("datetimeevents", category)
    where <- stringr::str_c(where, " and category = '", category, "'", sep = "")
  }

  m4_d_items(con, where = where) %>%
    dplyr::select(-linksto) %>%
    dplyr::arrange(category, itemid)
}

#' Access inputevents items reference
#'
#' This function provides base access to the d_items table which defines concepts recorded in the inputevents
#' table in the icu module.
#'
#' (PKEY `ITEMID`)
#'
#' @inheritParams m4_chartevents_items
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
#' tab <- m4_inputevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_inputevents_items <- function(con, category = character()) {
  where <- "where linksto = 'inputevents'"
  if (length(category) != 0) {
    category <- get_category("inputevents", category)
    where <- stringr::str_c(where, " and category = '", category, "'", sep = "")
  }

  m4_d_items(con, where = where) %>%
    dplyr::select(-linksto) %>%
    dplyr::arrange(category, itemid)
}

#' Access outputevents items reference
#'
#' This function provides base access to the d_items table which defines concepts recorded in the outputevents
#' table in the icu module.
#'
#' (PKEY `ITEMID`)
#'
#' @inheritParams m4_chartevents_items
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
#' tab <- m4_outputevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_outputevents_items <- function(con, category = character()) {
  where <- "where linksto = 'outputevents'"
  if (length(category) != 0) {
    category <- get_category("outputevents", category)
    where <- stringr::str_c(where, " and category = '", category, "'", sep = "")
  }

  m4_d_items(con, where = where) %>%
    dplyr::select(-linksto) %>%
    dplyr::arrange(category, itemid)
}

#' Access procedureevents items reference
#'
#' This function provides base access to the d_items table which defines concepts recorded in the procedureevents
#' table in the icu module.
#'
#' (PKEY `ITEMID`)
#'
#' @inheritParams m4_chartevents_items
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
#' tab <- m4_procedureevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_procedureevents_items <- function(con, category = character()) {
  where <- "where linksto = 'procedureevents'"
  if (length(category) != 0) {
    category <- get_category("procedureevents", category)
    where <- stringr::str_c(where, " and category = '", category, "'", sep = "")
  }

  m4_d_items(con, where = where) %>%
    dplyr::select(-linksto) %>%
    dplyr::arrange(category, itemid)
}

#' Access dimension table for hcpcsevents; provides a description of CPT codes
#'
#' This function provides base access to the d_hcpcs table which defines concepts recorded in the hcpcsevents
#' table in the hospital module.
#'
#' (PKEY `code`)
#'
#' @inheritParams m4_d_items
#'
#' @returns a tibble with the results.
#' @export
#' @examples
#' con <- bigrquery::dbConnect(
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
#' )
#'
#' tab <- m4_d_hcpcs(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_d_hcpcs <- function(con, ...) {
  m4_get_from_table(con, mimic4_table_name("d_hcpcs"), ...) %>%
    dplyr::arrange(code)
}

#' Access dimension table for diagnoses_icd; provides a description of ICD-9/ICD-10 billed diagnoses
#'
#' This function provides base access to the d_icd_diagnoses table which defines concepts recorded in the diagnoses_icd
#' table in the hospital module.
#'
#' (PKEY `icd_code`, `icd_version`)
#'
#' @inheritParams m4_d_items
#'
#' @returns a tibble with the results.
#' @export
#' @examples
#' con <- bigrquery::dbConnect(
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
#' )
#'
#' tab <- m4_d_icd_diagnoses(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_d_icd_diagnoses <- function(con, ...) {
  m4_get_from_table(con, mimic4_table_name("d_icd_diagnoses"), ...) %>%
    dplyr::arrange(icd_code, icd_version)
}

#' Access dimension table for procedures_icd; provides a description of ICD-9/ICD-10 billed procedures
#'
#' (PKEY `icd_code`, `icd_version`)
#'
#' This function provides base access to the d_icd_procedures table which defines concepts recorded in the
#' procedures_icd table in the hospital module.
#'
#' @inheritParams m4_d_items
#'
#' @returns a tibble with the results.
#' @export
#' @examples
#' con <- bigrquery::dbConnect(
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
#' )
#'
#' tab <- m4_d_icd_procedures(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_d_icd_procedures <- function(con, ...) {
  m4_get_from_table(con, mimic4_table_name("d_icd_procedures"), ...) %>%
    dplyr::arrange(icd_code, icd_version)
}

#' Access dimension table for labevents; provides a description of all lab items
#'
#' This function provides base access to the d_labitems table which defines concepts recorded in the
#' labevents table in the hospital module.
#'
#' (PKEY `itemid`)
#'
#' @inheritParams m4_d_items
#'
#' @returns a tibble with the results.
#' @export
#' @examples
#' con <- bigrquery::dbConnect(
#'   bigrquery::bigquery(),
#'   project = bigrquery::bq_test_project(),
#'   quiet = TRUE
#' )
#'
#' tab <- m4_d_labitems(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_d_labitems <- function(con, ...) {
  m4_get_from_table(con, mimic4_table_name("d_labitems"), ...) %>%
    dplyr::arrange(itemid)
}
