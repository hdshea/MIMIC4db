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
