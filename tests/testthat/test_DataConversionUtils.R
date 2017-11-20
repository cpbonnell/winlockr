library(testthat)
library(stringr)
context('Data format and type conversiont')

test_that('binary and hex translations work', {

  ## Overhead calculations
  n.raw.bytes <- 16
  n.hex.chars <- n.raw.bytes*3 - 1
  #raw.form <- PKI::PKI.random(n.raw.bytes)
  #hex.form <- raw_to_hex(raw.form)
  hex.form <- generate_salt(n.raw.bytes)
  raw.form <- hex_to_raw(hex.form)

  recovered.raw.form <- hex_to_raw(hex.form)
  recovered.hex.form <- raw_to_hex(raw.form)

  ## Expectations
  expect_equal(recovered.hex.form, hex.form)
  expect_equal(length(raw.form), n.raw.bytes)
  expect_equal(str_length(recovered.hex.form), n.hex.chars)
})
