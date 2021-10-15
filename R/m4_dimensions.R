# helper functions to help make sure that dimension tables
# and subsetted dimensions tables are efficiently queried
..dim_table_env <- rlang::env(dim_table_list = list())

get_cached_dim_table <- function(name) {
  ..dim_table_env$dim_tale_list[[name]]
}

set_cached_dim_table <- function(name, items) {
  ..dim_table_env$dim_tale_list[[name]] <- items
}

subset_d_items <- function(con, try_linksto = character(), try_category = character()) {
  stopifnot(is.character(try_linksto), length(try_linksto) == 1)
  stopifnot(try_linksto %in% c("chartevents", "datetimeevents", "inputevents", "outputevents", "procedureevents"))

  rval <- m4_d_items(con) %>%
    dplyr::filter(linksto == try_linksto) %>%
    dplyr::select(-linksto) %>%
    dplyr::arrange(category, itemid)

  if (length(try_category) != 0) {
    try_category <- get_category(try_linksto, try_category)
    rval <- rval %>%
      dplyr::filter(category == try_category)
  }

  rval
}

#' Access dimension table describing itemid
#'
#' This function provides base access to the d_items table which defines concepts recorded in the events table in
#' the icu module.
#'
#' Table attributes for d_items table:
#'
#' (**PKEY** `itemid`) reference data for all event tables
#'
#' @param con A [bigrquery::bigquery()] DBIConnection object, as returned by [DBI::dbConnect()]
#' with an appropriate [bigrquery::bigquery()] DBI driver specified in the call.
#' @param ... additional optional passed along parameters.
#'
#' @returns a tibble with the results.
#' @export
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
#' tab <- m4_d_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_d_items <- function(con, ...) {
  if (is.null(rval <- get_cached_dim_table("d_items"))) {
    rval <- m4_get_from_table(con, "d_items", ...) %>%
      dplyr::arrange(linksto, itemid)
    rval <- set_cached_dim_table("d_items", rval)
  }

  rval
}

#' Access chartevents items reference
#'
#' This function provides base access to the d_items table which defines concepts recorded in the chartevents table in
#' the icu module.
#'
#' Table attributes for chartevents_items sub-table:
#'
#' (**PKEY** `itemid`) reference data for chartevents table
#'
#' @param con A [bigrquery::bigquery()] DBIConnection object, as returned by [DBI::dbConnect()]
#' with an appropriate [bigrquery::bigquery()] DBI driver specified in the call.
#' @param category an character string defining the item category of interest
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
#' tab <- m4_chartevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_chartevents_items <- function(con, category = character()) {
  subset_d_items(con, "chartevents", category)
}

#' Access datetimeevents items reference
#'
#' This function provides base access to the d_items table which defines concepts recorded in the datetimeevents
#' table in the icu module.
#'
#' Table attributes for datetimeevents_items sub-table:
#'
#' (**PKEY** `itemid`) reference data for datetimeevents table
#'
#' @inheritParams m4_chartevents_items
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
#' tab <- m4_datetimeevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_datetimeevents_items <- function(con, category = character()) {
  subset_d_items(con, "datetimeevents", category)
}

#' Access inputevents items reference
#'
#' This function provides base access to the d_items table which defines concepts recorded in the inputevents
#' table in the icu module.
#'
#' Table attributes for inputevents_items sub-table:
#'
#' (**PKEY** `itemid`) reference data for inputevents table
#'
#' @inheritParams m4_chartevents_items
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
#' tab <- m4_inputevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_inputevents_items <- function(con, category = character()) {
  subset_d_items(con, "inputevents", category)
}

#' Access outputevents items reference
#'
#' This function provides base access to the d_items table which defines concepts recorded in the outputevents
#' table in the icu module.
#'
#' Table attributes for outputevents_items sub-table:
#'
#' (**PKEY** `itemid`) reference data for outputevents table
#'
#' @inheritParams m4_chartevents_items
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
#' tab <- m4_outputevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_outputevents_items <- function(con, category = character()) {
  subset_d_items(con, "outputevents", category)
}

#' Access procedureevents items reference
#'
#' This function provides base access to the d_items table which defines concepts recorded in the procedureevents
#' table in the icu module.
#'
#' Table attributes for procedureevents_items sub-table:
#'
#' (**PKEY** `itemid`) reference data for procedureevents table
#'
#' @inheritParams m4_chartevents_items
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
#' tab <- m4_procedureevents_items(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_procedureevents_items <- function(con, category = character()) {
  subset_d_items(con, "procedureevents", category)
}

#' Access dimension table for hcpcsevents; provides a description of CPT codes
#'
#' This function provides base access to the d_hcpcs table which defines concepts recorded in the hcpcsevents
#' table in the hospital module.
#'
#' Table attributes for d_hcpcs table:
#'
#' (**PKEY** `code`) reference data for hcpcsevents table
#'
#' @inheritParams m4_d_items
#'
#' @returns a tibble with the results.
#' @export
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
#' tab <- m4_d_hcpcs(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_d_hcpcs <- function(con, ...) {
  if (is.null(rval <- get_cached_dim_table("d_hcpcs"))) {
    rval <-
      m4_get_from_table(con, "d_hcpcs", ...) %>%
      dplyr::arrange(code)
    rval <- set_cached_dim_table("d_hcpcs", rval)
  }

  rval
}

#' Access dimension table for diagnoses_icd; provides a description of ICD-9/ICD-10 billed diagnoses
#'
#' This function provides base access to the d_icd_diagnoses table which defines concepts recorded in the diagnoses_icd
#' table in the hospital module.
#'
#' Table attributes for d_icd_diagnoses table:
#'
#' (**PKEY** `icd_code`, `icd_version`) reference data for diagnoses_icd table
#'
#' @inheritParams m4_d_items
#'
#' @returns a tibble with the results.
#' @export
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
#' tab <- m4_d_icd_diagnoses(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_d_icd_diagnoses <- function(con, ...) {
  if (is.null(rval <- get_cached_dim_table("d_icd_diagnoses"))) {
    rval <-
      m4_get_from_table(con, "d_icd_diagnoses", ...) %>%
      dplyr::arrange(icd_code, icd_version)
    rval <- set_cached_dim_table("d_icd_diagnoses", rval)
  }

  rval
}

#' Access dimension table for procedures_icd; provides a description of ICD-9/ICD-10 billed procedures
#'
#' This function provides base access to the d_icd_procedures table which defines concepts recorded in the
#' procedures_icd table in the hospital module.
#'
#' Table attributes for d_icd_procedures table:
#'
#' (**PKEY** `icd_code`, `icd_version`) reference data for procedures_icd table
#'
#' @inheritParams m4_d_items
#'
#' @returns a tibble with the results.
#' @export
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
#' tab <- m4_d_icd_procedures(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_d_icd_procedures <- function(con, ...) {
  if (is.null(rval <- get_cached_dim_table("d_icd_procedures"))) {
    rval <-
      m4_get_from_table(con, "d_icd_procedures", ...) %>%
      dplyr::arrange(icd_code, icd_version)
    rval <- set_cached_dim_table("d_icd_procedures", rval)
  }

  rval
}

#' Access dimension table for labevents; provides a description of all lab items
#'
#' This function provides base access to the d_labitems table which defines concepts recorded in the
#' labevents table in the hospital module.
#'
#' Table attributes for d_labitems table:
#'
#' (**PKEY** `itemid`) reference data for labevents table
#'
#' @inheritParams m4_d_items
#'
#' @returns a tibble with the results.
#' @export
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
#' tab <- m4_d_labitems(con)
#' tab
#'
#' bigrquery::dbDisconnect(con)
m4_d_labitems <- function(con, ...) {
  if (is.null(rval <- get_cached_dim_table("d_labitems"))) {
    rval <-
      m4_get_from_table(con, "d_labitems", ...) %>%
      dplyr::arrange(itemid)
    rval <- set_cached_dim_table("d_labitems", rval)
  }

  rval
}
