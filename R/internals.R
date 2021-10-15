# Creates a valid MIMIC-IV project.schema.table reference for the table specified by the `tname` parameter
#
mimic4_table_name <- function(tname) {
  rval <- NULL
  if (!is.null(tname)) {
    rval <- m4_meta_data() %>%
      dplyr::filter(table == tname) %>%
      dplyr::transmute(statement = stringr::str_c("physionet-data.", module, ".", table)) %>%
      dplyr::pull(statement)
  }

  rval
}

# In the m4_ base table and common pattern functions, the concept of a cohort is a group of subjects identified
# by numeric subject IDs
#
# A cohort can be:
#
# * NULL, indicating the entire MIMIC-IV population
# * a single SUBJECT_ID for an indivdual, or
# * a vector of SUBJECT_IDs for a proper subset of the entire population.
cohort_where <- function(cohort) {
  rval <- NULL
  if (!is.null(cohort)) {
    rval <- ifelse(
      length(cohort) == 1,
      stringr::str_c("WHERE subject_id = ", cohort),
      stringr::str_c("WHERE subject_id IN (", stringr::str_c(cohort, collapse = ", "), ")")
    )
  }

  rval
}

# In the m4_ base table and common pattern functions, the concept of an item list is a group of event items
# identified by numeric item IDs
#
# A item list can be:
#
# * NULL, indicating the every item
# * a single ITEMID for an individual ITEMID, or
# * a list of ITEMIDs for a proper subset of the eveny items.
itemlist_where <- function(itemlist) {
  rval <- NULL
  if (!is.null(itemlist)) {
    rval <- ifelse(
      length(itemlist) == 1,
      stringr::str_c("WHERE itemid = ", itemlist),
      stringr::str_c("WHERE itemid IN (", stringr::str_c(itemlist, collapse = ", "), ")")
    )
  }

  rval
}

# This helper function handles the cases where a cohort and an itemlist are needed within an m4_ base or common
# pattern function
#
# The strategy employed is to use the underlying `cohort_where` and `itemlist_where` helper functions and modify the
# resultant strings appropriately if necessary
combined_where <- function(cohort = NULL, itemlist = NULL) {
  cw <- cohort_where(cohort)
  iw <- itemlist_where(itemlist)

  if (!is.null(cw) & is.null(iw)) { # only cohort specified
    rval <- cw
  } else if (is.null(cw) & !is.null(iw)) { # only itemlist specified
    rval <- iw
  } else if (is.null(cw) & is.null(iw)) { # only itemlist specified
    rval <- NULL
  } else { # cohort and itemlist specified
    iw <- stringr::str_replace(iw, "^WHERE", "AND")
    rval <- stringr::str_c(cw, iw, sep = " ")
  }

  rval
}

# The function returns an appropriate `category` code for the specified `linksto` table indicating the events
# table where the `d_items` for apply.  The routine attempts to ignore case and white space in determining the
# appropriate `category` code.
#
get_category <- function(try_linksto, try_category) {
  stopifnot(is.character(try_linksto), length(try_linksto) == 1)
  stopifnot(try_linksto %in% c("chartevents", "datetimeevents", "inputevents", "outputevents", "procedureevents"))
  stopifnot(is.character(try_category), length(try_category) == 1, !identical(try_category, ""))

  tibble::tribble(
    ~linksto, ~category,
    "chartevents", "ADT",
    "chartevents", "Access Lines - Invasive",
    "chartevents", "Access Lines - Peripheral",
    "chartevents", "Adm History/FHPA",
    "chartevents", "Alarms",
    "chartevents", "ApacheII Parameters",
    "chartevents", "ApacheIV Parameters",
    "chartevents", "Arterial Line Insertion",
    "chartevents", "Bronchoscopy",
    "chartevents", "CVL Insertion",
    "chartevents", "Cardiovascular",
    "chartevents", "Cardiovascular (Pacer Data)",
    "chartevents", "Cardiovascular (Pulses)",
    "chartevents", "Care Plans",
    "chartevents", "Case Management",
    "chartevents", "Centrimag",
    "chartevents", "Dialysis",
    "chartevents", "Durable VAD",
    "chartevents", "ECMO",
    "chartevents", "Family Mtg Note",
    "chartevents", "GI/GU",
    "chartevents", "General",
    "chartevents", "Generic Proc Note",
    "chartevents", "Heartware",
    "chartevents", "Hemodynamics",
    "chartevents", "IABP",
    "chartevents", "Impella",
    "chartevents", "Intubation",
    "chartevents", "Labs",
    "chartevents", "Lumbar Puncture",
    "chartevents", "MD Progress Note",
    "chartevents", "Medications",
    "chartevents", "NICOM",
    "chartevents", "Neurological",
    "chartevents", "Nutrition - Enteral",
    "chartevents", "OB-GYN",
    "chartevents", "OT Notes",
    "chartevents", "PA Line Insertion",
    "chartevents", "PICC Line Insertion",
    "chartevents", "Pain/Sedation",
    "chartevents", "Paracentesis",
    "chartevents", "Pastoral Care Note",
    "chartevents", "PiCCO",
    "chartevents", "Pulmonary",
    "chartevents", "RDOS",
    "chartevents", "RNTriggerNote",
    "chartevents", "Respiratory",
    "chartevents", "Restraint/Support Systems",
    "chartevents", "Routine Vital Signs",
    "chartevents", "SBNET",
    "chartevents", "Scores - APACHE II",
    "chartevents", "Scores - APACHE IV",
    "chartevents", "Scores - APACHE IV (2)",
    "chartevents", "Skin - Assessment",
    "chartevents", "Skin - Impairment",
    "chartevents", "Skin - Incisions",
    "chartevents", "Swallow Evaluation",
    "chartevents", "Tandem Heart",
    "chartevents", "Thoracentesis",
    "chartevents", "Toxicology",
    "chartevents", "Treatments",
    "chartevents", "Triggers Note",
    "chartevents", "ZIntake",
    "datetimeevents", "ADT",
    "datetimeevents", "Access Lines - Invasive",
    "datetimeevents", "Access Lines - Peripheral",
    "datetimeevents", "Adm History/FHPA",
    "datetimeevents", "Care Plans",
    "datetimeevents", "Family Mtg Note",
    "datetimeevents", "GI/GU",
    "datetimeevents", "General",
    "datetimeevents", "Hemodynamics",
    "datetimeevents", "Labs",
    "datetimeevents", "OT Notes",
    "datetimeevents", "Pastoral Care Note",
    "datetimeevents", "Research Enrollment Note",
    "datetimeevents", "Skin - Impairment",
    "inputevents", "Antibiotics",
    "inputevents", "Blood Products/Colloids",
    "inputevents", "Fluids - Other (Not In Use)",
    "inputevents", "Fluids/Intake",
    "inputevents", "Medications",
    "inputevents", "Nutrition - Enteral",
    "inputevents", "Nutrition - Parenteral",
    "inputevents", "Nutrition - Supplements",
    "outputevents", "Drains",
    "outputevents", "Output",
    "procedureevents", "1-Intubation/Extubation",
    "procedureevents", "2-Ventilation",
    "procedureevents", "3-Significant Events",
    "procedureevents", "4-Procedures",
    "procedureevents", "5-Imaging",
    "procedureevents", "6-Cultures",
    "procedureevents", "7-Communication",
    "procedureevents", "Access Lines - Invasive",
    "procedureevents", "Access Lines - Peripheral",
    "procedureevents", "Dialysis",
    "procedureevents", "GI/GU",
    "procedureevents", "Medications"
  ) %>%
    dplyr::filter(toupper(linksto) == toupper(stringr::str_squish(try_linksto))) %>%
    dplyr::filter(toupper(category) == toupper(stringr::str_squish(try_category))) %>%
    dplyr::pull(category)
}
