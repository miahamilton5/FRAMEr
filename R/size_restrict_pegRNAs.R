
##determines size of eventual oligos and matched controls and removes pegRNAs that will be too large

size_restrict_pegRNAs <- function(x, five_prime_overhang = "GTGGAAAGGACGAAACACC", tevopreq1 = "CGCGGTTCTATCTAGTTACGCGTTAAACCAACTAGAA", terminator = "TTTTTTT", barcode_length = 7, three_prime_overhang = "AGATCGGAAGAGCACACGTC", matched_controls = TRUE) {
  oligo_length = (stringr::str_length(five_prime_overhang) + stringr::str_length(x$pegRNA) + stringr::str_length(tevopreq1) + stringr::str_length(terminator) +  stringr::str_length(x$reporter) + stringr::str_length(three_prime_overhang) + barcode_length)
  x$oligo_length <- oligo_length
  x
  ##add if else statement for factoring in length of matched controls
}
