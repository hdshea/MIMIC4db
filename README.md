
<!-- README.md is generated from README.Rmd. Please edit that file -->

# MIMIC4db

<!-- badges: start -->
<!-- badges: end -->

This work references data from the Medical Information Mart for
Intensive Care MIMIC-IV database. MIMIC-IV is a large, freely-available
database comprising de-identified health-related data from patients who
were admitted to the critical care units of the Beth Israel Deaconess
Medical Center from 2008-2019. Detailed information can be obtained on
the [MIMIC-IV website](https://mimic.mit.edu/docs/iv/).

MIMIC4db provides a tightly bound set of routines to reference the
Google BigQuery version of the [MIMIC-IV
v1.0](https://physionet.org/content/mimiciii/1.0/) database using base
access routines from the [DBI](https://github.com/r-dbi/DBI) R package
with an appropriate [bigrquery](https://github.com/r-dbi/bigrquery)
DBIConnection.

## Installation

You can install MIMIC4db from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("hdshea/MIMIC4db")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(MIMIC4db)
# To run examples, you must have the BIGQUERY_TEST_PROJECT environment
# variable set to name of project which has billing set up and to which
# you have write access.

## basic example code
```

## Citations for MIMIC-IV publications:

Johnson, A., Bulgarelli, L., Pollard, T., Horng, S., Celi, L. A., &
Mark, R. (2021). MIMIC-IV (version 1.0). PhysioNet.
<https://doi.org/10.13026/s6n6-xd98>.

**PhysioNet**: Goldberger, A., Amaral, L., Glass, L., Hausdorff, J.,
Ivanov, P. C., Mark, R., … & Stanley, H. E. (2000). PhysioBank,
PhysioToolkit, and PhysioNet: Components of a new research resource for
complex physiologic signals. Circulation \[Online\]. 101 (23),
pp. e215–e220.
