
##this function adds a new column to the aggregated PRIDICT output table containing the reporter sequence

format_reporter <- function(pegRNAs = x) {
  ##ensure data.table
  PRIDICT_targeting_pegRNAs_all <- data.table::as.data.table(pegRNAs)
  # Initialize columns: PBSlocation, RT_initial_location, RT_mutated_location
  cols <- c("protospacerlocation_only_initial", "PBSlocation", "RT_initial_location")
  # Remove brackets and split values into start and end
  for (col in cols) {
    start_vals <- as.integer(sub("\\]", "", sub("\\[", "", data.table::tstrsplit(PRIDICT_targeting_pegRNAs_all[[col]], ",")[[1]])))
    end_vals <- as.integer(sub("\\]", "", data.table::tstrsplit(PRIDICT_targeting_pegRNAs_all[[col]], ",")[[2]]))

    PRIDICT_targeting_pegRNAs_all[[paste0(col, "_start")]] <- start_vals
    PRIDICT_targeting_pegRNAs_all[[paste0(col, "_end")]] <- end_vals
  }

  PRIDICT_targeting_pegRNAs_all <- PRIDICT_targeting_pegRNAs_all %>%
    dplyr::mutate(protospacerlocation_only_initial_end_plus_PAM = (protospacerlocation_only_initial_end + 3))

  ## find genomic coordinates of minimal target sequence by finding the minimal window in wide_initial_target that the pegRNA would need to bind to
  ## find min and max coordinates (0-based)
  PRIDICT_targeting_pegRNAs_all <- PRIDICT_targeting_pegRNAs_all %>%
    dplyr::mutate(min_index = base::pmin(protospacerlocation_only_initial_start, protospacerlocation_only_initial_end, PBSlocation_start, PBSlocation_end, RT_initial_location_start, RT_initial_location_end, protospacerlocation_only_initial_end_plus_PAM)) %>%
    dplyr::mutate(max_index = base::pmax(protospacerlocation_only_initial_start, protospacerlocation_only_initial_end, PBSlocation_start, PBSlocation_end, RT_initial_location_start, RT_initial_location_end, protospacerlocation_only_initial_end_plus_PAM))

  ##format reporter
  PRIDICT_targeting_pegRNAs_all_reporter <- PRIDICT_targeting_pegRNAs_all %>%
    dplyr::relocate(min_index, max_index) %>%
    dplyr::mutate(reporter = substr(wide_initial_target, min_index, max_index)) %>%
    dplyr::relocate(sequence_name, reporter) %>%
    dplyr::select(!c(min_index, max_index, protospacerlocation_only_initial_start, protospacerlocation_only_initial_end, PBSlocation_start, PBSlocation_end, RT_initial_location_start, RT_initial_location_end, protospacerlocation_only_initial_end_plus_PAM))

  PRIDICT_targeting_pegRNAs_all_reporter
}
