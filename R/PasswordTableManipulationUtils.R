


#' Remove all passwords in the table that are beyond their expiration date
PurgeExpiredPasswords <- function(df){
  df %>% filter(expiration <= lubridate::now())
}


#' Rebuild the password locker from scratch
CreatePasswordLocker <- function(){

  df <- tibble::data_frame(
    username = character(),
    application = character(),
    expiration = character(),
    salt = character(),
    password = character()
  )

  return(df)
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

