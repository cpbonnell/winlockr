


GetLockerPath <- function(){
  file.path(find.package('winlocker'), 'locker', 'passwordLocker.rds')
}

#' Rebuild the password locker from scratch
CreatePasswordLocker <- function(){

  df <- data_frame(
    username = character(),
    application = character(),
    expiration = character(),
    salt = character(),
    password = character()
  )

  return(df)
}

#' Remove all passwords in the table that are beyond their expiration date
PurgeExpiredPasswords <- function(df){
  df %>% filter(expiration <= lubridate::now())
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





#' Delete all stored
PurgeAllPasswords <- function(username = NULL){

  if(!is.null(username)){
    relevant <- ReadPasswordTable() %>%
      filter(username != username) %>%
      WritePasswordTable()

  } else{
    remove.file(GetLockerPath())
  }
  invisible()
}

#' Add an encrypted password to the data frame
StoreEncryptedPassword <- function(username, application, expiration, salt, password){

  pw.locker <- ReadPasswordTable()

  new.row <- list(
    username = usn,
    application = apl,
    expiration = expir,
    salt = salt,
    password = password
  )

  pw.locker <- rbind(pw.locker, new.row)
  WritePasswordTable(pw.locker)
  invisible()
}

#' Retrieve an encrypted password from the data frame
RetrieveEncryptedPassword <- function(username, application){

  pw.locker <- readr::read_rds(GetLockerPath())
  pw.locker <- PurgeExpiredPasswords(pw.locker)

  relevant <- pw.locker %>%
    filter(username == username, application == application)

  if(nrow(relevant) < 1){
    result <- c(password = NA, salt = NA)
  } else {
    result <- c(
      password = relevant[[1, 'password']],
      salt = relevant[[1, 'salt']]
    )
  }

  return(result)
}
