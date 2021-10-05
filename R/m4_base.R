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
#' x <- 5
m4_select_data <- function(con, select_statement) {
    res <- DBI::dbSendQuery(con, select_statement)
    rval <- DBI::dbFetch(res)
    DBI::dbClearResult(res)
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
#' x <- 5
m4_get_from_table <- function(con, table, where = NULL) {
    m4_select_data(con, stringr::str_c("SELECT * FROM", table, where, sep = " "))
}
