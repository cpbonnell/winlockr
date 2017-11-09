
library(testthat)
context('PasswordTableManipulation')




test_that('Password table creation makes an appropriate table.',{

  df <- CreatePasswordTable()

  expect_equal(nrow(df), 0)
  expect_true('username' %in% names(df))
  expect_true('application' %in% names(df))

})


test_that('Adding passwords to the table works appropriately', {

  df <- CreatePasswordTable()
  #df <- TableAddPassword(df, 'abc1234', 'my_application', NA, 'x', 'x' )
  df <- TableAddPassword(df, 'abc1234', 'my_application', NA, 'aa bb cc', '1a 22 fd' )
  df <- TableAddPassword(df, 'abc1234', NA, '2015-01-01 1:00:00', 'dd ee ff', 'fa 71 6d' )

  expect_equal(nrow(df), 2)
  expect_true('default_password' %in% df$application)
  expect_true('my_application' %in% df$application)
  #expect_true(!'x' %in% df$password)
  #expect_true(!'x' %in% df$salt)

})
