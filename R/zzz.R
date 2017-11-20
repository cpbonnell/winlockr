

#DONE(cpb)<2017-11-20>: use reg.finalizer() to set up code to delete session passwords
# when the user quits R
.onLoad <- function(libname, pkgname){

  parent <- parent.env(environment())

  reg.finalizer(parent, LockerExpirePasswords, onexit = TRUE)
}



