






#' Prompt the user for a password and store it for later use
#'
#' Store the user's password on disk in an encrypted form. This encrypted
#' form can only be decrypted when the user is logged into their Windows
#' account. Other users cannot decrypt it even if they have access to the hard
#' drive with administrator privileges.
#'
#' Encryption is done using 3DES with a 128 bit salt to protect password privacy
#' across multiple systems even if they use the same password.
#'
#' @param user The username associated with the password
#' @param applicaiton The application that the username and password should be used for
#' @param expiration Coercible to a datetime object
#'
#' @export
RememberPassword <- function(user, application, expiration = NA){

  ## Generate a salt to be used for the encryption
  salt <- PKI::PKI.random(128)

  ## Prompt for the password and
  msg <- 'Please enter your password:'
  encrypted.pwd <- CryptProtectData(.rs.askForPassword(msg), salt)

  #DONE(cpb): finish this function after writing more helper functions
  StoreEncryptedPassword(user, application, expiration, salt, encrypted.pwd)
  invisible()
}
