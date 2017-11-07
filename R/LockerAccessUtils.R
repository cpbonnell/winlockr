
#' @importFrom magrittr %>%
NULL
# NULL

#library(dplyr)


GetLockerPath <- function(){
  file.path(find.package('winlockr'), 'locker', 'passwordLocker.rds')
}


#' Retrieve the password table, purging expired passwords along the way
ReadPasswordTable <- function(){

  if(!file.exists(GetLockerPath())){
    df <- CreatePasswordLocker()
  } else {
    df <- readr::read_rds(GetLockerPath())
    df <- PurgeExpiredPasswords(df)
  }

  return(df)
}

#' Write the password table back to file
WritePasswordTable <- function(df){
  readr::write_rds(df, GetLockerPath())
  invisible()
}




#' Add an encrypted password to the data frame
StoreEncryptedPassword <- function(username, application, expiration, salt, password){
  require(tibble)
  require(dplyr)

  pw.locker <- ReadPasswordTable()

  pw.locker <- pw.locker %>%
    add_row(
      username = username,
      application = application,
      expiration = expiration,
      salt = salt,
      password = password
    )

  WritePasswordTable(pw.locker)
  invisible()
}

#' Retrieve an encrypted password from the data frame
RetrieveEncryptedPassword <- function(username, application){

  pw.locker <- ReadPasswordTable()

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
