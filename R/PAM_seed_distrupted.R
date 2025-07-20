##this function adds a new column to the aggregated PRIDICT output table with a TRUE or FALSE value if the PAM and/or seed regions are disrupted

PAM_seed_disrupted <- function(pegRNAs) {
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

  PRIDICT_targeting_pegRNAs_all %>%
    dplyr::mutate(edit_first_base = deepeditposition + 1,
           edit_last_base = dplyr::case_when(
      Correction_Type == "Deletion" ~ deepeditposition + 1 + stringr::str_length(Original_Sequence) - stringr::str_length(Edited_Sequence) - 1,
      Correction_Type == "Replacement" ~ deepeditposition + 1 + Correction_Length - 1,
      Correction_Type == "Insertion" ~  deepeditposition + 1 + stringr::str_length(Edited_Sequence) - stringr::str_length(Original_Sequence)
    )) %>%
    dplyr::mutate(PAM_first_G = protospacerlocation_only_initial_end_plus_PAM-1, PAM_second_G = protospacerlocation_only_initial_end_plus_PAM) %>%
    dplyr::relocate(edit_first_base, edit_last_base, PAM_first_G, PAM_second_G) %>%
    dplyr::mutate(PAM_mutated = dplyr::case_when(
      edit_first_base <= PAM_first_G & edit_last_base >= PAM_first_G ~ TRUE,
      edit_first_base <= PAM_second_G & edit_last_base >= PAM_second_G ~ TRUE,
      edit_first_base <= PAM_first_G & edit_last_base >= PAM_second_G ~ TRUE,
      TRUE ~ FALSE
    )) %>%
    dplyr::mutate(seed_mutated = dplyr::case_when(
      edit_first_base >= PAM_first_G - 11 & edit_first_base <= PAM_first_G - 2 ~ TRUE,
      edit_last_base >= PAM_first_G - 11 & edit_last_base <= PAM_first_G - 2 ~ TRUE,
      edit_first_base <= PAM_first_G - 11 & edit_last_base >= PAM_first_G - 11 ~ TRUE,
      edit_first_base <= PAM_first_G - 2 & edit_last_base >= PAM_first_G - 2 ~ TRUE,
      TRUE ~ FALSE
    )) %>%
    dplyr::mutate(indel_in_spam = dplyr::case_when(
      (Correction_Type == "Deletion" | Correction_Type == "Insertion") & (edit_first_base >= PAM_first_G - 21 & edit_first_base <= PAM_second_G) ~ TRUE,
      (Correction_Type == "Deletion" | Correction_Type == "Insertion") & (edit_last_base >= PAM_first_G - 21 & edit_last_base <= PAM_second_G) ~ TRUE,
      (Correction_Type == "Deletion" | Correction_Type == "Insertion") & (edit_first_base <= PAM_first_G - 21 & edit_last_base >= PAM_first_G - 21) ~ TRUE,
      (Correction_Type == "Deletion" | Correction_Type == "Insertion") & (edit_first_base <= PAM_second_G & edit_last_base >= PAM_second_G) ~ TRUE,
      TRUE ~ FALSE
    )) %>%
    dplyr::mutate(PAM_or_seed_mutated = dplyr::case_when(
      (PAM_mutated == TRUE | seed_mutated == TRUE | indel_in_spam == TRUE) ~ TRUE,
      TRUE ~ FALSE
    )) %>%
    dplyr::relocate(sequence_name, PAM_or_seed_mutated) %>%
    dplyr::select(!c(edit_first_base, edit_last_base, PAM_first_G, PAM_second_G, PAM_mutated, seed_mutated, indel_in_spam, protospacerlocation_only_initial_start, protospacerlocation_only_initial_end, PBSlocation_start, PBSlocation_end, RT_initial_location_start, RT_initial_location_end, protospacerlocation_only_initial_end_plus_PAM))


}
