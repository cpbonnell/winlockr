






#' Single function password management
#'
#' This function is intended to ease the use of this package's functionality in
#' other packages. InsertPassword() wraps the functionality of both
#' RememberPassword() and RetrievePassword(), and provides notification to the
#' user of what is being done with their password when they enter it.
#'
#' @param user The username associated with the password
#' @param applicaiton The application that the username and password should be used for
#' @param expiration.date Coercible to a datetime object of the form "y-m-d h:m:s"
#' @param expiration.duration A names list indicating the number of days, hours, and minutes until the password should expire
#'
#' @export
InsertPassword <- function(user, application = NA, expiration.date = NA, expiration.duration = NA){

  ##============================================================
  ## First check to see if the password is already on file... if it is not then
  ## we run the code to acquire it.
  if(!LockerHasPassword(user, application)){
    ## Start by constructing a string to inform the user of what is being
    ## done with their password.

    if(!is.na(expiration.date)){
      message <- sprintf('The "%s" application would like to use your password. It will be kept until %s using the winlocker package.',
                         application, format(expiration.date))
    } else if(!is.na(expiration.duration)){

      quantity <- 0
      if('days' %in% names(expiration.duration)) quantity <- quantity + expiration.duration[['days']]
      if('hours' %in% names(expiration.duration)) quantity <- quantity + expiration.duration[['hours']]/24
      if('minutes' %in% names(expiration.duration)) quantity <- quantity + expiration.duration[['minutes']]/1440

      message <- sprintf('The "%s" application would like to use your password. It will be kept for %.2f days using the winlocker package.',
                         application, quantity)
    } else {
      message <- sprintf('The "%s" application would like to use your password. It will be kept until midnight using the winlocker package.',
                         application)
    }

    ## Now pass control to RememberPassword to prompt and store the password
    RememberPassword(user, application, expiration.date, expiration.duration, message)
  }


  ##============================================================
  ## The password is already in file, so we can just return it.

  return(RetrievePassword(user, application))
}
