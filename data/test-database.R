## test-database.R

context("Database checks")

test_that("Correct tables are in the database", {
  expect_that(all(grepl("nesreanigeria", tables)), is_true())
  expect_that("nesreanigeria_tweets" %in% tables, is_true())
  expect_that("nesreanigeria_fbposts" %in% tables, is_true())
  expect_that("nesreanigeria_fblikes" %in% tables, is_true())
  expect_that("nesreanigeria_fbcomments" %in% tables, is_true())
  expect_that("nesreanigeria_webnews" %in% tables, is_true())
  expect_that("sometable" %in% tables, is_false())
})


