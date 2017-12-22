## test-facebook.R

context("Facebook Access Token")

test_that("Attributes of token object", {
  expect_is(nesreaToken, "mytoken")
  expect_is(nesreaToken$token, "Token2.0")
  expect_is(nesreaToken$token, "Token")
  expect_is(nesreaToken$token, "R6")
  expect_is(nesreaToken$token, "v2")
  expect_true(nesreaToken$expiryDate > Sys.Date())
})