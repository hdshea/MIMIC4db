% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/m4_core.R
\name{m4_transfers}
\alias{m4_transfers}
\title{Access patient movement from bed to bed within the hospital, including ICU admission and discharge}
\usage{
m4_transfers(con, cohort = NULL, ...)
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
This function provides base access to the transfers table containing information about the physical locations
for patients throughout their hospital stay.
}
\details{
Table attributes for transfers table:

(\strong{PKEY} \code{subject_id}, \code{hadm_id}, \code{transfer_id})

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

trn <- m4_transfers(con, cohort = 10137012)
dim(trn)

bigrquery::dbDisconnect(con)
}
