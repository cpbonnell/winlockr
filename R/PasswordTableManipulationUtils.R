


# Rebuild the password table from scratch
CreatePasswordTable <- function(){

  df <- tibble::data_frame(
    username = character(),
    application = character(),
    expiration = character(),
    salt = character(),
    password = character()
  )

  return(df)
}


# Remove all passwords in the table that are beyond their expiration date
TablePurgeExpiredPasswords <- function(df){
  df %>% filter(expiration <= lubridate::now())
}

TablePurgeSessionPasswords <- function(df){
  df %>% filter(!is.na(expiration))
}

# Add a new row tothe password table
TableAddPassword <- function(df, username, application, expiration, salt, password) {

  ## Handle NA values where needed
  application <- ifelse(is.na(application), 'default_password', application)

  ## Check if the username/password combination is already in the table, and if
  ## so then delete it before adding the new record
  current <- TableGetPassword(df, username, application)
  if(!is.na(current$username)){
    df <- TableRemovePassword(df, username, password)
  }

  ## Now write the password with associated information to the table and return
  ## the modified data frame.
  result <- df %>% add_row(
    username = username,
    application = application,
    expiration = expiration,
    salt = salt,
    password = password
  )

  result
}

# Get a stored password and salt from the table... return NA's for both if
# they are not in the table
TableGetPassword <- function(df, username, application){

  ## Handle NA values where needed
  application <- ifelse(is.na(application), 'default_password', application)

  relevant <- df %>% filter(username == username, application == application)

  if(nrow(relevant) > 0){
    result <- c(
      'password' = relevant[[1, 'password']],
      'salt' = relevant[[1, 'salt']]
    )
  } else {
    result <- c('password' = NA, 'salt' = NA)
  }

  result
}

# Remove the password associated with a given username and application. Passing
# NA for the application will remove all entries associated with the username
# regardless of application.
TableRemovePassword <- function(df, username, application = NA){

  if(is.na(application)){
    result <- filter(df, username != username)
  } else {
    result <- filter_(df, username != username, !application %in% c('default_password', application))
  }

  result
}


