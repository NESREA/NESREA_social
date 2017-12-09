## test-build.R
library(tm, quietly = TRUE)
suppressPackageStartupMessages(library(qdap, quietly = TRUE))

context("Functions for build process")

test_that("compute_emotional_valence() works", {
  expect_equal(class(compute_emotional_valence(txt)), "list")
  expect_equal(typeof(compute_emotional_valence(txt)), "list")
  expect_equal(length(compute_emotional_valence(txt)), length(txt))
})

test_that("Tabulation of positive/negative works", {
  expect_equal(class(make_word_table(result)), "list")
  expect_output(str(make_word_table(result)), "List of 2")
})

test_that("Corpus is properly created", {
  expect_equal(class(make_corpus(txt)), c("VCorpus", "Corpus"))
  expect_output(str(make_corpus(txt)), "List of 3")
})

test_that("Correct platform can be identified", {
  expect_equal(choose_platform("TWItTEr"), 1)
  expect_equal(choose_platform("FACebOOk"), 2)
  expect_error(choose_platform("Others"), "Provide a supported")
})



