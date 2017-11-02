library(testthat)
library(stringr)
context('Data format and type conversiont')

test_that('binary and hex translations work', {

  ## Overhead calculations
  n.raw.bytes <- 16
  n.hex.chars <- n.raw.bytes*3 - 1
  raw.form <- PKI::PKI.random(n.raw.bytes)
  hex.form <- raw_to_hex(raw.form)
  recovered.raw.form <- hex_to_raw(hex.form)

  ## Expectations
  expect_equal(recovered.raw.form, raw.form)
  expect_equal(str_length(hex.form), n.hex.chars)
})
