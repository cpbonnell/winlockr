

.winlockr.canary <- new.env()

reg.finalizer(.winlockr.canary, function(e) {
  message('Object Bye!')
}, onexit = TRUE)

f <- function(env){
  LockerExpirePasswords()
  print(ls(env))
  message('Bye from namespace finalizer!')
}

#DONE(cpb)<2017-11-20>: use reg.finalizer() to set up code to delete session passwords
# when the user quits R
.onLoad <- function(libname, pkgname){

  parent <- parent.env(environment())

  reg.finalizer(parent, f, onexit = TRUE)
}



