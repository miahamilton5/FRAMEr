
##
## FIX MULTIBASE SUBSTITUTIONS
##
##Sequentially add in matched controls to a dataframe and export it

reverse_complement <- function(sequence) {
  # Replace nucleotides with their complements
  complement <- chartr("ATCGatcg", "TAGCtagc", sequence)
  # Reverse the sequence
  stringi::stri_reverse(complement)
}

create_matched_controls <- function(pegRNAs) {

  matched_deletions <- pegRNAs %>%
    dplyr::filter(EditedAllele == "-") %>%
    dplyr::mutate(
      matched_RTrevcomp = ifelse(
        str_starts(RTrevcomp, RTseqoverhangrevcomp),
        paste0(
          RTseqoverhangrevcomp,
          reverse_complement(OriginalAllele),
          str_sub(RTrevcomp, str_length(RTseqoverhangrevcomp) + 1)
        ),
        NA_character_
      ))

  ##replace the overhang trailing base with the reverse comp of OriginalAllele
  matched_substitutions <- pegRNAs  %>%
    filter(Correction_Type == "Replacement") %>%
    rowwise() %>%
    mutate(
      matched_RTrevcomp = if (str_starts(RTrevcomp, RTseqoverhangrevcomp)) {
        prefix <- RTseqoverhangrevcomp
        suffix <- str_sub(RTrevcomp, str_length(prefix) + 2)  # skip the trailing base ## may need to fix this for multibase substitutions!!
        replacement <- reverse_complement(OriginalAllele)
        paste0(prefix, replacement, suffix)
      } else {
        NA_character_
      }
    ) %>%
    ungroup()

if(c("-") %in% test$OriginalAllele == TRUE) {

  matched_insertions <- pegRNAs %>%
    filter(OriginalAllele == "-") %>%
    rowwise() %>%
    mutate(
      matched_RTrevcomp = {
        # Normalize case to uppercase for comparison
        rt <- toupper(RTrevcomp)
        overhang <- toupper(RTseqoverhangrevcomp)
        edited_rc <- toupper(reverse_complement(EditedAllele))

        if (str_starts(rt, overhang)) {
          trailing <- str_sub(rt, str_length(overhang) + 1)

          # Match length: count how many starting bases of trailing match edited_rc
          match_len <- 0
          for (i in seq_len(min(nchar(trailing), nchar(edited_rc)))) {
            if (substr(trailing, i, i) == substr(edited_rc, i, i)) {
              match_len <- i
            } else {
              break
            }
          }

          new_trailing <- str_sub(RTrevcomp, str_length(RTseqoverhangrevcomp) + match_len + 1)
          paste0(RTseqoverhangrevcomp, new_trailing)
        } else {
          NA_character_
        }
      }
    ) %>%
    ungroup()

  rbind(matched_controls, matched_insertions)
}

}
