#' Access dimension table describing itemid. Defines concepts recorded in the events table in
#' the ICU module
#'
#' (PKEY `itemid`)
#'
#' @param con A DBIConnection object, as returned by [DBI::dbConnect()] object with an appropriate
#' [bigrquery](https://github.com/r-dbi/bigrquery) DBIConnection.
#' @param ... additional optional passed along parameters.
#'
#' @returns a tibble with the results.
#' @export
#' @examples
#' con <- bigrquery::dbConnect(
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#'
#' tab <- m4_d_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_d_items <- function(con, ...) {
    m4_get_from_table(con, mimic4_table_name("d_items"), ...) %>%
        dplyr::arrange(linksto,itemid)
}

#' Access chartevent items reference
#'
#' (PKEY `ITEMID`)
#'
#' @param con A DBIConnection object, as returned by [DBI::dbConnect()] object with an appropriate
#' [bigrquery](https://github.com/r-dbi/bigrquery) DBIConnection.
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
#' tab <- m4_chartevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_chartevents_items <- function(con) {
    m4_d_items(con, where = "where linksto = 'chartevents'") %>%
        dplyr::select(-linksto) %>%
        dplyr::arrange(itemid)
}

#' Access datetimeevents items reference
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
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#'
#' tab <- m4_datetimeevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_datetimeevents_items <- function(con) {
    m4_d_items(con, where = "where linksto = 'datetimeevents'") %>%
        dplyr::select(-linksto) %>%
        dplyr::arrange(itemid)
}

#' Access inputevents items reference
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
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#'
#' tab <- m4_inputevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_inputevents_items <- function(con) {
    m4_d_items(con, where = "where linksto = 'inputevents'") %>%
        dplyr::select(-linksto) %>%
        dplyr::arrange(itemid)
}

#' Access outputevents items reference
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
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#'
#' tab <- m4_outputevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_outputevents_items <- function(con) {
    m4_d_items(con, where = "where linksto = 'outputevents'") %>%
        dplyr::select(-linksto) %>%
        dplyr::arrange(itemid)
}

#' Access procedureevents items reference
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
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#'
#' tab <- m4_procedureevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_procedureevents_items <- function(con) {
    m4_d_items(con, where = "where linksto = 'procedureevents'") %>%
        dplyr::select(-linksto) %>%
        dplyr::arrange(itemid)
}

#' Access imension table for hcpcsevents; provides a description of CPT codes
#'
#' (PKEY `code`)
#'
#' @inheritParams m4_d_items
#'
#' @returns a tibble with the results.
#' @export
#' @examples
#' con <- bigrquery::dbConnect(
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
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
#' (PKEY `icd_code`, `icd_version`)
#'
#' @inheritParams m4_d_items
#'
#' @returns a tibble with the results.
#' @export
#' @examples
#' con <- bigrquery::dbConnect(
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#'
#' tab <- m4_d_icd_diagnoses(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_d_icd_diagnoses <- function(con, ...) {
    m4_get_from_table(con, mimic4_table_name("d_icd_diagnoses"), ...) %>%
        dplyr::arrange(icd_code,icd_version)
}

#' Access dimension table for procedures_icd; provides a description of ICD-9/ICD-10 billed procedures
#'
#' (PKEY `icd_code`, `icd_version`)
#'
#' @inheritParams m4_d_items
#'
#' @returns a tibble with the results.
#' @export
#' @examples
#' con <- bigrquery::dbConnect(
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#'
#' tab <- m4_d_icd_procedures(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_d_icd_procedures <- function(con, ...) {
    m4_get_from_table(con, mimic4_table_name("d_icd_procedures"), ...) %>%
        dplyr::arrange(icd_code,icd_version)
}

#' Access dimension table for labevents; provides a description of all lab items
#'
#' (PKEY `itemid`)
#'
#' @inheritParams m4_d_items
#'
#' @returns a tibble with the results.
#' @export
#' @examples
#' con <- bigrquery::dbConnect(
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
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
