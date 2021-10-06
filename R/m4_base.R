#' @importFrom magrittr %>%
NULL

#' Basic SELECT statement wrapper returning results in a tibble
#'
#' Wrapper around DBI functions to send a \code{SELECT} statement, fetch the results
#' and return them in a tibble.
#'
#' @param con A DBIConnection object, as returned by [DBI::dbConnect()] object with an appropriate
#' [bigrquery](https://github.com/r-dbi/bigrquery) DBIConnection.
#' @param select_statement a character string representing a SQL \code{SELECT} statement.
#'
#' @returns a tibble with the results.
#' @export
#'
#' @examples
#' # To run examples, you must have the BIGQUERY_TEST_PROJECT environment
#' # variable set to name of project which has billing set up and to which
#' # you have write access.
#' con <- bigrquery::dbConnect(
#'     bigrquery::bigquery(),
#'     project = bigrquery::bq_test_project(),
#'     quiet = TRUE
#' )
#' m4_select_data(con, "select * from physionet-data.mimic_icu.d_items order by itemid limit 5")
#' bigrquery::dbDisconnect(con)
m4_select_data <- function(con, select_statement) {
    res <- bigrquery::dbSendQuery(con, select_statement)
    rval <- bigrquery::dbFetch(res)
    bigrquery::dbClearResult(res)
    rval
}

#' Simple generic SELECT * wrapper for extracting data from base tables
#'
#' Helper function to perform a basic \code{SELECT *} from the noted table projected down by the optional
#' where clause.
#'
#' @param con  A DBIConnection object, as returned by dbConnect().
#' @param table a character string representing a valid MIMIC-IV table name.
#' @param where a character string representing a SQL \code{WHERE} clause.
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
#' m4_get_from_table(con, "physionet-data.mimic_icu.d_items", where = "where itemid <= 220048")
#' bigrquery::dbDisconnect(con)
m4_get_from_table <- function(con, table, where = NULL) {
    m4_select_data(con, stringr::str_c("SELECT * FROM", table, where, sep = " "))
}
