% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/m4_hosp.R
\name{m4_emar}
\alias{m4_emar}
\title{Access Electronic Medicine Administration Records (eMAR)}
\usage{
m4_emar(con, cohort = NULL, ...)
}
\arguments{
\item{con}{A \code{\link[bigrquery:bigquery]{bigrquery::bigquery()}} DBIConnection object, as returned by \code{\link[DBI:dbConnect]{DBI::dbConnect()}}
with an appropriate \code{\link[bigrquery:bigquery]{bigrquery::bigquery()}} DBI driver specified in the call.}

\item{cohort}{an optional vector of patient IDs defining the cohort of interest}

\item{...}{additional optional passed along parameters.}
}
\value{
a tibble with the results.
}
\description{
This functions provides base access to the emar table from the hospital module.  These data are
collected by barcode scanning of medications at the time of administration.
}
\details{
Table attributes for emar table:

(\strong{PKEY} \code{emar_id}, \code{emar_seq})

(\strong{FKEY} \code{subject_id}) -> patients table

(\strong{FKEY} \code{hadm_id}) -> admissions table

(\strong{FKEY} \code{emar_id}, \code{emar_seq}) -> emar_detail table

(\strong{FKEY} \code{pharmacy_id}) -> pharmacy table

(\strong{FKEY} \code{pharmacy_id}) -> prescriptions table

(\strong{FKEY} \code{poe_id}) -> poe table
}
\examples{
# To run examples, you must have the BIGQUERY_TEST_PROJECT environment
# variable set to name of project which has billing set up and to which
# you have write access.
con <- bigrquery::dbConnect(
  bigrquery::bigquery(),
  project = bigrquery::bq_test_project(),
  quiet = TRUE
)

emar <- m4_emar(con, cohort = 10137012)
dim(emar)

bigrquery::dbDisconnect(con)
}
