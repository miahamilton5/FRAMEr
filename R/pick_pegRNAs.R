

pick_pegRNAs <- function(pegRNAs, number_of_pegRNAs, PRIDICT_celltype, remove_PAM_seed_disrupted = FALSE, PRIDICT_threshold = NA) {

  if(remove_PAM_seed_disrupted == TRUE){
    pegRNAs <- pegRNAs %>%
      dplyr::filter(PAM_or_seed_mutated == FALSE)
  }

  if(PRIDICT_celltype == "HEK"){

    pegRNAs <- pegRNAs %>%
      dplyr::arrange(desc(PRIDICT2_0_editing_Score_deep_HEK)) %>%
      dplyr::group_by(sequence_name) %>%
      dplyr::slice_head(n = number_of_pegRNAs) %>%
      dplyr::ungroup()

    if(!is.na(PRIDICT_threshold)){
      pegRNAs_passing_threshold <- pegRNAs %>%
        dplyr::filter(PRIDICT2_0_editing_Score_deep_HEK >= PRIDICT_threshold) %>%
        dplyr::distinct(sequence_name)

      pegRNAs <- pegRNAs %>%
        dplyr::filter(pegRNAs$sequence_name %in% pegRNAs_passing_threshold$sequence_name)
    }
}
    if(PRIDICT_celltype == "K562"){

      pegRNAs <- pegRNAs %>%
        dplyr::arrange(desc(PRIDICT2_0_editing_Score_deep_K562)) %>%
        dplyr::group_by(sequence_name) %>%
        dplyr::slice_head(n = number_of_pegRNAs) %>%
        dplyr::ungroup()

      if(!is.na(PRIDICT_threshold)){
        pegRNAs_passing_threshold <- pegRNAs %>%
          dplyr::filter(PRIDICT2_0_editing_Score_deep_K562 >= PRIDICT_threshold) %>%
          dplyr::distinct(sequence_name)

        pegRNAs <- pegRNAs %>%
          dplyr::filter(pegRNAs$sequence_name %in% pegRNAs_passing_threshold$sequence_name)
      }

      }

    pegRNAs
    }
