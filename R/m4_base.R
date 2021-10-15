#' Basic SELECT statement wrapper returning results in a tibble
#'
#' Wrapper around DBI functions to send a \code{SELECT} statement, fetch the results
#' and return them in a tibble.
#'
#' @param con A [bigrquery::bigquery()] DBIConnection object, as returned by [DBI::dbConnect()]
#' with an appropriate [bigrquery::bigquery()] DBI driver specified in the call.
#' @param select a character string representing a SQL \code{SELECT} statement.
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
#' m4_select_data(con, "select * from physionet-data.mimic_icu.d_items order by itemid limit 5")
#'
#' bigrquery::dbDisconnect(con)
m4_select_data <- function(con, select) {
  stopifnot(identical(class(con)[1],"BigQueryConnection"))
  stopifnot(is.character(select), length(select) == 1, !identical(stringr::str_squish(select),""))

  res <- bigrquery::dbSendQuery(con, select, quiet = TRUE)
  rval <- bigrquery::dbFetch(res, quiet = TRUE)
  bigrquery::dbClearResult(res, quiet = TRUE)

  rval
}

#' Simple generic SELECT * wrapper for extracting data from base tables
#'
#' Function to perform a basic \code{SELECT *} from the noted table projected down by the optional
#' where clause.
#'
#' @param con A [bigrquery::bigquery()] DBIConnection object, as returned by [DBI::dbConnect()]
#' with an appropriate [bigrquery::bigquery()] DBI driver specified in the call.
#' @param table a character string representing a valid MIMIC-IV table name.
#' @param where an optional character string representing a SQL \code{WHERE} clause.
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
#' m4_get_from_table(con, "d_items", where = "where itemid <= 220048")
#'
#' bigrquery::dbDisconnect(con)
m4_get_from_table <- function(con, table, where = NULL) {
  stopifnot(is.character(table), length(table) == 1)
  table <- tolower(table)
  stopifnot(table %in% m4_meta_data()$table)

  m4_select_data(con, stringr::str_c("SELECT * FROM", mimic4_table_name(table), where, sep = " "))
}
