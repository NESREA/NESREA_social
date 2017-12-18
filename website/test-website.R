## test-website.R
suppressPackageStartupMessages(library(rvest, quietly = TRUE))

context("Website downloads")

test_that("Test site is appropriate", {
  expect_that(exampleDotCom, is_a("xml_document"))
  expect_that(exampleDotCom, is_a("xml_node"))
})

test_that("Data is scraped from the website", {
  scrape.test <- function(tag) scrape_items(exampleDotCom, tag)
  
  expect_equal(scrape.test("h1"), "Example Domain")
  expect_equal(typeof(scrape.test("p")), "character")
  expect_true(gregexpr("domain", scrape.test("p"))[[1]][1] == 6)
  expect_true(gregexpr("domain", scrape.test("p"))[[1]][2] == 101)
  expect_warning(scrape.test("h"), "wrong CSS selector was used")
  expect_silent(scrape.test("p"))
})
