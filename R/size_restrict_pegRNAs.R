
##determines size of eventual oligos and matched controls and removes pegRNAs that will be too large

size_restrict_pegRNAs <- function(pegRNAs, five_prime_overhang = "GTGGAAAGGACGAAACACC", tevopreq1 = "CGCGGTTCTATCTAGTTACGCGTTAAACCAACTAGAA", terminator = "TTTTTTT", barcode_length = 7, three_prime_overhang = "AGATCGGAAGAGCACACGTC", matched_controls = TRUE, size_limit = 300) {
  oligo_length = (stringr::str_length(five_prime_overhang) + stringr::str_length(pegRNAs$pegRNA) + stringr::str_length(tevopreq1) + stringr::str_length(terminator) +  stringr::str_length(pegRNAs$reporter) + stringr::str_length(three_prime_overhang) + barcode_length)
  pegRNAs$oligo_length <- oligo_length
  pegRNAs <- pegRNAs %>%
    dplyr::filter(oligo_length <= size_limit) %>%
    dplyr::relocate(sequence_name, oligo_length)

  ##add if statement for factoring in length of matched controls
  if (matched_controls == TRUE) {
    pegRNAs <- pegRNAs %>%
      dplyr::mutate(matched_control_length = dplyr::case_when(
        Correction_Type == "Replacement" ~ oligo_length,
        Correction_Type == "Insertion" ~ oligo_length - Correction_Length,
        Correction_Type == "Deletion" ~ oligo_length + Correction_Length
      )) %>%
      dplyr::filter(matched_control_length <= size_limit) %>%
      dplyr::relocate(sequence_name, oligo_length, matched_control_length)
  }

  ##print filtered list
  pegRNAs

}
