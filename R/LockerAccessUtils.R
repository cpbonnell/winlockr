
#' @importFrom magrittr %>%
#' @importFrom dplyr filter
NULL
# NULL


LockerGetPath <- function(){
  file.path(find.package('winlockr'), 'locker', 'password_locker.rds')
}


#' Retrieve the password table, purging expired passwords along the way
#'
#' This function is currently exported for diagnostic purposes only
#' @export
LockerReadTable <- function(){

  if(!file.exists(LockerGetPath())){
    df <- CreatePasswordTable()
  } else {
    df <- readr::read_rds(LockerGetPath())
    df <- TablePurgeExpiredPasswords(df)
  }

  return(df)
}

#' Write the password table back to file
LockerWriteTable <- function(df){
  readr::write_rds(df, LockerGetPath())
  invisible()
}




#' Add an encrypted password to the data frame
LockerStorePassword <- function(username, application, expiration, salt, password){

  pw.locker <- LockerReadTable()

  pw.locker <- TableAddPassword(pw.locker, username, application, expiration, salt, password)

  LockerWriteTable(pw.locker)
  invisible()
}



#' Retrieve an encrypted password from the data frame
LockerGetPassword <- function(username, application){

  pw.locker <- LockerReadTable()

  creds <- TableGetPassword(pw.locker, username, application)

  return(creds)
}


LockerExpirePasswords <- function(env = NULL){
  df <- LockerReadTable()
  df <- TablePurgeExpiredPasswords(df)
  LockerWriteTable(df)
  invisible()
}


