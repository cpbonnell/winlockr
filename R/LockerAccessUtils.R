
#' @importFrom magrittr %>%
NULL
# NULL


LockerGetPath <- function(){
  file.path(find.package('winlockr'), 'locker', 'passwordLocker.rds')
}


#' Retrieve the password table, purging expired passwords along the way
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

  relevant <- pw.locker %>% filter(username == username, application == application)

  if(nrow(relevant) < 1){
    result <- c(password = NA, salt = NA)
  } else {
    result <- lst(
      password = relevant[[1, 'password']],
      salt = relevant[[1, 'salt']]
    )
  }

  return(result)
}


