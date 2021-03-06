% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/m4_dimensions.R
\name{m4_d_icd_procedures}
\alias{m4_d_icd_procedures}
\title{Access dimension table for procedures_icd; provides a description of ICD-9/ICD-10 billed procedures}
\usage{
m4_d_icd_procedures(con, ...)
}
\arguments{
\item{con}{A \code{\link[bigrquery:bigquery]{bigrquery::bigquery()}} DBIConnection object, as returned by \code{\link[DBI:dbConnect]{DBI::dbConnect()}}
with an appropriate \code{\link[bigrquery:bigquery]{bigrquery::bigquery()}} DBI driver specified in the call.}

\item{...}{additional optional passed along parameters.}
}
\value{
a tibble with the results.
}
\description{
This function provides base access to the d_icd_procedures table which defines concepts recorded in the
procedures_icd table in the hospital module.
}
\details{
Table attributes for d_icd_procedures table:

(\strong{PKEY} \code{icd_code}, \code{icd_version}) reference data for procedures_icd table
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

tab <- m4_d_icd_procedures(con)
tab

bigrquery::dbDisconnect(con)
}
