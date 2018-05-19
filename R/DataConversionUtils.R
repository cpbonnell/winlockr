
#' @useDynLib winlocker
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


#' Generate a string of hex values to serve as our salt
generate_salt <- function(n){

  bytes <- character()

  for(i in 1:n){
    b <- sample(x=c('0','1','2','3','4','5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'), 2)
    b <- paste0(b, collapse = '')

    bytes = c(bytes, b)
  }

  paste0(bytes, collapse = ' ')
}




