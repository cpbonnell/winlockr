
library(testthat)
context('PasswordTableManipulation')




test_that('Password table creation makes an appropriate table.',{

  df <- CreatePasswordTable()

  expect_equal(nrow(df), 0)
  expect_true('username' %in% names(df))
  expect_true('application' %in% names(df))

})


test_that('Looking up passwords works correctly.', {


  df <- tibble::tribble(
    ~username, ~application, ~expiration, ~salt, ~password,
    'aaa1111', 'some_app', NA, 'aa aa aa', '11 11 11',
    'aaa1111', 'default_password', NA, 'bb bb bb', '22 22 22'
  )


  expect_equal(TableGetPassword(df, 'aaa1111', 'some_app'),
               c(password='11 11 11', salt='aa aa aa'))

  expect_equal(TableGetPassword(df, 'aaa1111'),
               c(password='22 22 22', salt='bb bb bb'))

  expect_true(all(is.na(TableGetPassword(df, 'bbb2222', 'some_app'))))

  expect_true(all(is.na(TableGetPassword(df, 'bbb2222'))))
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
