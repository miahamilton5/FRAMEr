
##takes directory of PRIDICT2 predictions (.csv)
##binds all PRIDICT output files into one data table from .csvs

bind_csv <- function(input_directory) {
  af <- base::list.files(input_directory, pattern='*.csv')
  all <- data.table::rbindlist(lapply(af, function(p) { data.table::fread(paste0(input_directory, p)) }))
  all
}
