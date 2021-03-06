% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/m4_icu.R
\name{m4_icustays}
\alias{m4_icustays}
\title{Access tracking information for ICU stays including admissions and discharge times}
\usage{
m4_icustays(con, cohort = NULL, ...)
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
This function provides base access to the icustays table containing data which represents the tracking
information for ICU stays including admissions and discharge times.
}
\details{
Table attributes for icustays table:

(\strong{PKEY} \code{subject_id}, \code{hadm_id}, \code{stay_id})

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

stays <- m4_icustays(con, cohort = 12384098)
dim(stays)

bigrquery::dbDisconnect(con)
}
