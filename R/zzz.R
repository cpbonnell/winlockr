

.winlockr.canary <- new.env()

#DONE(cpb)<2017-11-20>: use reg.finalizer() to set up code to delete session passwords
# when the user quits R
.onLoad <- function(libname, pkgname){

  e <- parent.env(environment())
  f <- function(env){
    LockerExpirePasswords()
    print(ls(env))
    env$LockerExpirePasswords()
    message('Bye from namespace finalizer!')
  }

  reg.finalizer(e, f, onexit = TRUE)
}



