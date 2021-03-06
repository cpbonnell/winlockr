






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
#' If an expiration is not specified, the password will expire at midnight on
#' the day it was entered.
#'
#' @param user The username associated with the password
#' @param applicaiton The application that the username and password should be used for
#' @param expiration.date Coercible to a datetime object of the form "y-m-d h:m:s"
#' @param expiration.duration A names list indicating the number of days, hours, and minutes until the password should expire
#'
#' @export
RememberPassword <- function(user, application = NA, expiration.date = NA, expiration.duration = NA){

  ##============================================================
  ## Start by parsing expiration parameters and creating an actual expiration date

  if(!is.na(expiration.date) & expiration.date == 'session'){
    ## The user wants this to be a session password, so store a NA in the field
    #expiration <- NA

    ##... but this feature is not yet implemented, so we need to throw an eror
    stop('Session passwords are not yet implemented. Please specify an expiration timestamp, or use the default behavior.')

  } else if(!is.na(expiration.date)){

    ## Second case: the user has given us an actual expiration datetime
    expiration <- lubridate::ymd_hms(expiration.date)

  } else if(!is.na(expiration.duration)){

    ## Third case: the user has given us a list of time units specifying an
    ##   amount of time for which the password should be valid.
    expiration <- lubridate::now()

    if('days' %in% names(expiration.duration)){
      expiration <- expiration + lubridate::ddays(expiration.duration[['days']])
    }

    if('hours' %in% names(expiration.duration)){
      expiration <- expiration + lubridate::dhours(expiration.duration[['hours']])
    }

    if('minutes' %in% names(expiration.duration)){
      expiration <- expiration + lubridate::dminutes(expiration.duration[['minutes']])
    }

  } else {

    ## Fourth (and final) case: The user has not specified any expiration, so we
    ##   default to having it expire at midnight
    expiration <- lubridate::now()
    hour(expiration) <- 23
    minute(expiration) <- 59
    second(expiration) <- 59
  }




  ##============================================================
  ## Now do the actual work of encrypting the password and storing it

  ## Generate a salt to be used for the encryption
  #TODO(cpb): The function below is not available on CRAN, and requires that
  #   updates to the PKI package be downloaded from github. Since the salt
  #   does not need to be secret, much less cryptographically random, the
  #   function should probably be replaced. If a cryptographically secure
  #   random generator can be found with easier use, then that is probably still
  #   best.
  salt <- generate_salt(128)
  #salt <- PKI::PKI.random(128)

  ## Prompt for the password and
  msg <- 'Please enter your password:'
  encrypted.pwd <- CryptProtectData(charToRaw(.rs.askForPassword(msg)), hex_to_raw(salt))

  ## Put things in the right form to be stored
  hex.salt <- salt
  hex.pwd <- raw_to_hex(encrypted.pwd)

  #a <- ifelse(is.na(application), 'NA', application)
  LockerStorePassword(user, application, expiration, hex.salt, hex.pwd)
  invisible()
}
