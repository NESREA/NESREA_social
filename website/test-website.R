## test-website.R
suppressPackageStartupMessages(library(rvest, quietly = TRUE))

context("Website related functions")

test_that("Test site is appropriate", {
  expect_that(inherits(exampleDotCom, "xml_document"), is_true())
  expect_that(inherits(exampleDotCom, "xml_node"), is_true())
})

test_that("Data is scraped from the website", {
  expect_equal(scrape_items(exampleDotCom, "h1"), "Example Domain")
  expect_equal(typeof(scrape_items(exampleDotCom, "p")), "character")
  expect_that(
    gregexpr("domain", scrape_items(exampleDotCom, "p"))[[1]][1] == 6,
    is_true())
  expect_that(
    gregexpr("domain", scrape_items(exampleDotCom, "p"))[[1]][2] == 101,
    is_true())
})
