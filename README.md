
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
# To connect to the database, you must provide an appropriate project (in the `your-project` 
# slot below) which has billing set up and to which you have write access.  This project 
# must be approved to access the PhysioNet BigQuery MIMIC schemas.

con <- bigrquery::dbConnect(
    bigrquery::bigquery(),
    project = "your-project",
    quiet = TRUE
)
```

Using the meta data functions:

``` r
core <- m4_meta_data()
core <- core[core$module == "mimic_core", ]
for(i in 1:length(core)) {
  cat(stringr::str_c("select * from physionet-data.", 
                     core[i,"module"], ".", core[i,"table"], "\n"))
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
d_items <- m4_select_data(con, 
                          "select * from physionet-data.mimic_icu.d_items order by itemid limit 5")
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

d_items <- m4_get_from_table(con, "d_items", where = "where itemid <= 220048")
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
#>   itemid label     abbreviation    category   unitname param_type lownormalvalue
#>    <int> <chr>     <chr>           <chr>      <chr>    <chr>               <dbl>
#> 1 224188 PICC Lin… PICC Line Site… Access Li… <NA>     Text                   NA
#> 2 224281 Multi Lu… Multi Lumen Si… Access Li… <NA>     Text                   NA
#> 3 224283 Multi Lu… Multi Lumen Wa… Access Li… <NA>     Text                   NA
#> 4 224289 Arterial… Arterial line … Access Li… <NA>     Text                   NA
#> 5 224291 Arterial… Arterial line … Access Li… <NA>     Text                   NA
#> # … with 1 more variable: highnormalvalue <dbl>

pat <- m4_patients(con, cohort = 16904137)
pat
#> # A tibble: 1 × 6
#>   subject_id gender anchor_age anchor_year anchor_year_group dod   
#>        <int> <chr>       <int>       <int> <chr>             <date>
#> 1   16904137 M              54        2117 2017 - 2019       NA

svs <- m4_services(con, cohort = 16904137)
svs
#> # A tibble: 2 × 11
#>   subject_id  hadm_id transfertime        service_seq first_service curr_service
#>        <int>    <int> <dttm>                    <int> <lgl>         <chr>       
#> 1   16904137 21081215 2105-10-04 17:27:12           1 TRUE          SURG        
#> 2   16904137 22747535 2117-01-24 06:35:19           1 TRUE          SURG        
#> # … with 5 more variables: curr_short_desc <chr>, curr_description <chr>,
#> #   prev_service <chr>, prev_short_desc <chr>, prev_description <chr>

evt <- m4_procedureevents(con, cohort = 16904137)
evt[c(1:5), ]
#> # A tibble: 5 × 26
#>   subject_id  hadm_id  stay_id starttime           endtime            
#>        <int>    <int>    <int> <dttm>              <dttm>             
#> 1   16904137 22747535 34698721 2117-01-24 12:50:00 2117-01-26 17:51:00
#> 2   16904137 22747535 34698721 2117-01-24 12:50:00 2117-01-26 17:51:00
#> 3   16904137 22747535 34698721 2117-01-24 12:51:00 2117-01-26 17:51:00
#> 4   16904137 22747535 34698721 2117-01-24 12:51:00 2117-01-25 04:11:00
#> 5   16904137 22747535 34698721 2117-01-24 12:52:00 2117-01-26 17:51:00
#> # … with 21 more variables: storetime <dttm>, itemid <int>, value <dbl>,
#> #   valueuom <chr>, location <chr>, locationcategory <chr>, orderid <int>,
#> #   linkorderid <int>, ordercategoryname <chr>,
#> #   secondaryordercategoryname <chr>, ordercategorydescription <chr>,
#> #   patientweight <dbl>, totalamount <dbl>, totalamountuom <chr>,
#> #   isopenbag <int>, continueinnextdept <int>, cancelreason <int>,
#> #   statusdescription <chr>, comments_date <dttm>, ORIGINALAMOUNT <dbl>, …
```

Using the common pattern data access functions:

``` r
# Combined and preprocessed patient and admission data
patadm <- m4_patient_admissions(con, cohort = 16904137)
patadm[, c(1:6)]
#> # A tibble: 2 × 6
#>   subject_id  hadm_id gender dod    admission_seq first_admission
#>        <int>    <int> <chr>  <date>         <int> <lgl>          
#> 1   16904137 21081215 M      NA                 1 TRUE           
#> 2   16904137 22747535 M      NA                 2 FALSE
patadm[, c(7:10)]
#> # A tibble: 2 × 4
#>   admittime           dischtime           los_hospital admission_age
#>   <dttm>              <dttm>                     <dbl>         <dbl>
#> 1 2105-10-04 17:26:00 2105-10-12 11:11:00         7.74          42.8
#> 2 2117-01-24 06:33:00 2117-01-29 15:59:00         5.39          54.1
patadm[, c(11:14)]
#> # A tibble: 2 × 4
#>   admission_decade anchor_year_group admission_type admission_location    
#>   <fct>            <chr>             <fct>          <fct>                 
#> 1 [40,50)          2017 - 2019       URGENT         TRANSFER FROM HOSPITAL
#> 2 [50,60)          2017 - 2019       EW EMER.       TRANSFER FROM HOSPITAL
patadm[, c(15:19)]
#> # A tibble: 2 × 5
#>   discharge_location insurance ethnicity_group language marital_status
#>   <fct>              <fct>     <fct>           <fct>    <fct>         
#> 1 HOME               Other     OTHER           ENGLISH  MARRIED       
#> 2 HOME HEALTH CARE   Other     WHITE           ENGLISH  DIVORCED

# Combined and preprocessed patient, admission and icustay data
icudet <- m4_patient_icustays(con, cohort = 16904137)
icudet[, c(1:6)]
#> # A tibble: 2 × 6
#>   subject_id  hadm_id  stay_id gender dod    admission_seq
#>        <int>    <int>    <int> <chr>  <date>         <int>
#> 1   16904137 21081215       NA M      NA                 1
#> 2   16904137 22747535 34698721 M      NA                 2
icudet[, c(7:10)]
#> # A tibble: 2 × 4
#>   first_admission admittime           dischtime           los_hospital
#>   <lgl>           <dttm>              <dttm>                     <dbl>
#> 1 TRUE            2105-10-04 17:26:00 2105-10-12 11:11:00         7.74
#> 2 FALSE           2117-01-24 06:33:00 2117-01-29 15:59:00         5.39
icudet[, c(11:14)]
#> # A tibble: 2 × 4
#>   admission_age admission_decade anchor_year_group admission_type
#>           <dbl> <fct>            <chr>             <fct>         
#> 1          42.8 [40,50)          2017 - 2019       URGENT        
#> 2          54.1 [50,60)          2017 - 2019       EW EMER.
icudet[, c(15:19)]
#> # A tibble: 2 × 5
#>   admission_location     discharge_location insurance ethnicity_group language
#>   <fct>                  <fct>              <fct>     <fct>           <fct>   
#> 1 TRANSFER FROM HOSPITAL HOME               Other     OTHER           ENGLISH 
#> 2 TRANSFER FROM HOSPITAL HOME HEALTH CARE   Other     WHITE           ENGLISH
icudet[, c(20:22)]
#> # A tibble: 2 × 3
#>   marital_status icustay_seq first_icustay
#>   <fct>                <int> <lgl>        
#> 1 MARRIED                  1 TRUE         
#> 2 DIVORCED                 1 TRUE
icudet[, c(23:25)]
#> # A tibble: 2 × 3
#>   intime              outtime             los_icustay
#>   <dttm>              <dttm>                    <dbl>
#> 1 NA                  NA                        NA   
#> 2 2117-01-24 06:35:19 2117-01-26 17:51:20        2.47
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
