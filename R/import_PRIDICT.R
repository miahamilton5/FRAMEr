#' Import PRIDICT2 predictions (.csv)
#'
#' @description
#' binds all PRIDICT output files into one data table from .csvs
#' following classes:
#'
#'
#'

#' @param input_directory A directory.
#' @export

import_PRIDICT <- function(input_directory = input_directory) {
  af <- base::list.files(input_directory, pattern='*.csv')
  all <- data.table::rbindlist(lapply(af, function(p) { data.table::fread(paste0(input_directory, p)) }))
  return(all)
}
