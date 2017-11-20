

#DONE(cpb): use reg.finalizer() to set up code to delete session passwords
# when the user quits R
.winlockr.canary <- environment()
reg.finalizer(.winlockr.canary, LockerExpirePasswords, onexit = TRUE)

