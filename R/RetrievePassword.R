








#' Retrieve a stored password from the locker
#'
#' This function returns the plaintext password that a user previously stored.
#' The password is returned as a single string so that it can be simply passed
#' inline to whatever application requires it.
#'
#' @param user A string indicating the user being logged in
#' @param application A string indicating the application being logged into
#'
#' @export
RetrievePassword <- function(user, application){


  creds <- RetrieveEncryptedPassword(user, application)

  if(is.na(creds$password) || is.na(creds$salt)){
    return(NA)
  }

  raw.password <- hex_to_raw(creds$password)
  raw.salt <- hex_to_raw(creds$salt)
  return(as.character(CryptUnprotectData(raw.password, raw.salt)))
}