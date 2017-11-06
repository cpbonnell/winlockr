
#' @useDynLib winlockr
#' @importFrom Rcpp sourceCpp
NULL
# NULL



#' Contert a raw vector into a string of hex values
raw_to_hex <- function(raw_vector){
  paste0(as.character( raw_vector ), collapse = ' ')
}

#' Convert a string of hex values into a raw vector
hex_to_raw <- function(hex_string){
  as.raw(as.hexmode(strsplit( hex_string , split = ' ')[[1]]))
}
