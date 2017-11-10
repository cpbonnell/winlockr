
#' @importFrom dplyr filter
NULL
# NULL


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
TableAddPassword <- function(df, usr, app, expr, slt, pwd) {

  ## Handle NA values where needed
  apl <- ifelse(is.na(app), 'default_password', app)

  ## Check if the username/password combination is already in the table, and if
  ## so then delete it before adding the new record
  current <- TableGetPassword(df, usr, apl)
  if(!all(is.na(current))){
    df <- TableRemovePassword(df, usr, apl)
  }

  ## Now write the password with associated information to the table and return
  ## the modified data frame.
  result <- df %>% add_row(
    username = usr,
    application = apl,
    expiration = expr,
    salt = slt,
    password = pwd
  )

  result
}

# Get a stored password and salt from the table... return NA's for both if
# they are not in the table
TableGetPassword <- function(df, usr, app = NA){

  ## Handle NA values where needed
  apl <- ifelse(is.na(app), 'default_password', app)

  relevant <- df %>% filter(username == usr, application == apl)

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
TableRemovePassword <- function(df, usr, app = NA){

  if(is.na(app)){
    result <- filter(df, username != usr)
  } else {
    result <- filter(df, username != usr, application != app)
  }

  result
}


