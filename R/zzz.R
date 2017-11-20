

#DONE(cpb)<2017-11-20>: use reg.finalizer() to set up code to delete session passwords
# when the user quits R
.winlockr.canary <- environment()
.onLoad <- function(libname, pkgname){
  reg.finalizer(.winlockr.canary, LockerExpirePasswords, onexit = TRUE)
}



