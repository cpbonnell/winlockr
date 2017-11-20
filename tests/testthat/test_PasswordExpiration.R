
library(testthat)
context('PasswordExpiration')



test_that('Session passwords are removed at the end of the session.',{

  df <- CreatePasswordTable()
  df <- TableAddPassword(df, 'aaa', 'my_application', NA, 'x', 'x' )
  df <- TableAddPassword(df, 'bbb', 'my_application', '2017-12-31 01:00:00', 'y', 'y' )
  df <- TableAddPassword(df, 'ccc', 'my_application', '2015-01-01 01:00:00', 'z', 'z' )

  session <- TablePurgeSessionPasswords(df)
  expire <- TablePurgeExpiredPasswords(df)

  expect_equal(session$salt, c('y', 'z'))
  expect_equal(expire$salt, c('x', 'y'))
})

