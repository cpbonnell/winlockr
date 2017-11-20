

#.winlockr.canary <- new.env()

#TODO(cpb): use reg.finalizer() to set up code to delete session passwords
# when the user quits R
.onLoad <- function(libname, pkgname){

  # e <- parent.env(environment())
  # f <- function(env){
  #   fp <- file.path(find.package('winlockr'), 'locker', 'password_locker.rds')
  #
  #   if(!file.exists(fp)){
  #     return(invisible())
  #   } else {
  #     df <- readr::read_rds(LockerGetPath())
  #     df <- TablePurgeExpiredPasswords(df)
  #   }
  #
  #   df <- df %>% filter(is.na(expiration) | expiration >= lubridate::now())
  #
  #   readr::write_rds(df, fp)
  #   invisible()
  # }
  #
  # reg.finalizer(e, f, onexit = TRUE)


}



