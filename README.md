
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

## Basic Usage

These are basic examples which show you how to solve a common problem.

Connecting to the database:

``` r
library(MIMIC4db)
# To connect to the database, you must provide an appropriate project (in the `"your-project"` slot below)
# which has billing set up and to which you have write access.  This project must be approved to access
# the PhysioNet BigQuery MIMIC schemas.

con <- bigrquery::dbConnect(
    bigrquery::bigquery(),
    project = "your-project",
    quiet = TRUE
)
```

Using the meta data function:

``` r
core <- m4_meta_data()
core <- core[core$module == "mimic_core", ]
for(i in 1:length(core)) {
  cat(stringr::str_c("select * from physionet-data.", core[i,"module"], ".", core[i,"table"], "\n"))
}
#> select * from physionet-data.mimic_core.admissions
#> select * from physionet-data.mimic_core.patients
#> select * from physionet-data.mimic_core.transfers

neuro <- m4_service_decsriptions()
neuro <- neuro[startsWith(neuro$short_description, "Neurologic"), ]
neuro[,c("service", "short_description")]
#> # A tibble: 2 × 2
#>   service short_description  
#>   <chr>   <chr>              
#> 1 NMED    Neurologic Medical 
#> 2 NSURG   Neurologic Surgical
```

Using the two base functions:

``` r
d_items <- m4_select_data(con, "select * from physionet-data.mimic_icu.d_items order by itemid limit 5")
d_items
#> # A tibble: 5 × 9
#>   itemid label  abbreviation linksto category unitname param_type lownormalvalue
#>    <int> <chr>  <chr>        <chr>   <chr>    <chr>    <chr>               <dbl>
#> 1 220003 ICU A… ICU Admissi… dateti… ADT      <NA>     Date and …             NA
#> 2 220045 Heart… HR           charte… Routine… bpm      Numeric                NA
#> 3 220046 Heart… HR Alarm - … charte… Alarms   bpm      Numeric                NA
#> 4 220047 Heart… HR Alarm - … charte… Alarms   bpm      Numeric                NA
#> 5 220048 Heart… Heart Rhythm charte… Routine… <NA>     Text                   NA
#> # … with 1 more variable: highnormalvalue <dbl>

d_items <- m4_get_from_table(con, "physionet-data.mimic_icu.d_items", where = "where itemid <= 220048")
d_items
#> # A tibble: 5 × 9
#>   itemid label  abbreviation linksto category unitname param_type lownormalvalue
#>    <int> <chr>  <chr>        <chr>   <chr>    <chr>    <chr>               <dbl>
#> 1 220003 ICU A… ICU Admissi… dateti… ADT      <NA>     Date and …             NA
#> 2 220046 Heart… HR Alarm - … charte… Alarms   bpm      Numeric                NA
#> 3 220047 Heart… HR Alarm - … charte… Alarms   bpm      Numeric                NA
#> 4 220048 Heart… Heart Rhythm charte… Routine… <NA>     Text                   NA
#> 5 220045 Heart… HR           charte… Routine… bpm      Numeric                NA
#> # … with 1 more variable: highnormalvalue <dbl>
```

Using the tables specific data access functions:

``` r
tab <- m4_chartevents_items(con)
tab[c(1:5), ]
#> # A tibble: 5 × 8
#>   itemid label       abbreviation  category   unitname param_type lownormalvalue
#>    <int> <chr>       <chr>         <chr>      <chr>    <chr>               <dbl>
#> 1 220045 Heart Rate  HR            Routine V… bpm      Numeric                NA
#> 2 220046 Heart rate… HR Alarm - H… Alarms     bpm      Numeric                NA
#> 3 220047 Heart Rate… HR Alarm - L… Alarms     bpm      Numeric                NA
#> 4 220048 Heart Rhyt… Heart Rhythm  Routine V… <NA>     Text                   NA
#> 5 220050 Arterial B… ABPs          Routine V… mmHg     Numeric                90
#> # … with 1 more variable: highnormalvalue <dbl>

pat <- m4_patients(con, cohort = 10137012)
pat
#> # A tibble: 1 × 6
#>   subject_id gender anchor_age anchor_year anchor_year_group dod   
#>        <int> <chr>       <int>       <int> <chr>             <date>
#> 1   10137012 F               0        2110 2008 - 2010       NA

svs <- m4_services(con, cohort = 10137012)
svs[c(1:5), ]
#> # A tibble: 5 × 5
#>   subject_id  hadm_id transfertime        prev_service curr_service
#>        <int>    <int> <dttm>              <chr>        <chr>       
#> 1   10137012 26854842 2110-11-02 04:42:13 <NA>         NB          
#> 2         NA       NA NA                  <NA>         <NA>        
#> 3         NA       NA NA                  <NA>         <NA>        
#> 4         NA       NA NA                  <NA>         <NA>        
#> 5         NA       NA NA                  <NA>         <NA>

evt <- m4_procedureevents(con, cohort = 12384098)
evt[c(1:5), ]
#> # A tibble: 5 × 26
#>   subject_id  hadm_id  stay_id starttime           endtime            
#>        <int>    <int>    <int> <dttm>              <dttm>             
#> 1   12384098 26793165 39458824 2184-03-14 10:00:00 2184-03-14 11:29:00
#> 2   12384098 26793165 39458824 2184-03-14 10:00:00 2184-03-15 05:58:00
#> 3   12384098 26793165 39458824 2184-03-14 10:00:00 2184-03-14 11:28:00
#> 4   12384098 26793165 39458824 2184-03-14 11:00:00 2184-03-15 05:04:00
#> 5   12384098 26793165 39458824 2184-03-14 11:00:00 2184-03-15 20:04:00
#> # … with 21 more variables: storetime <dttm>, itemid <int>, value <dbl>,
#> #   valueuom <chr>, location <chr>, locationcategory <chr>, orderid <int>,
#> #   linkorderid <int>, ordercategoryname <chr>,
#> #   secondaryordercategoryname <chr>, ordercategorydescription <chr>,
#> #   patientweight <dbl>, totalamount <dbl>, totalamountuom <chr>,
#> #   isopenbag <int>, continueinnextdept <int>, cancelreason <int>,
#> #   statusdescription <chr>, comments_date <dttm>, ORIGINALAMOUNT <dbl>, …
```

Disconnecting from the database:

``` r
bigrquery::dbDisconnect(con)
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
