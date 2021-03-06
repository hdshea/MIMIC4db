% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/m4_hosp.R
\name{m4_drgcodes}
\alias{m4_drgcodes}
\title{Access billed DRG codes for hospitalizations}
\usage{
m4_drgcodes(con, cohort = NULL, ...)
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
This function provides base access to the drgcodes table containing data pertaining to diagnosis related groups
(DRGs) which are used by the hospital to obtain reimbursement for a patient’s hospital stay. The codes correspond
to the primary reason for a patient’s stay at the hospital.
}
\details{
Table attributes for drgcodes table:

(\strong{PKEY} \code{subject_id}, \code{hadm_id}, \code{drg_type}, \code{drg_code})

(\strong{FKEY} \code{subject_id}) -> patients table

(\strong{FKEY} \code{hadm_id}) -> admissions table
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

drgc <- m4_drgcodes(con, cohort = 10137012)
dim(drgc)

bigrquery::dbDisconnect(con)
}
