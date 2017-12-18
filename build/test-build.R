## test-build.R
library(tm, quietly = TRUE)
suppressPackageStartupMessages(library(qdap, quietly = TRUE))

context("Workspace preparation")

test_that("Input for package installation or loading is correct", {
  mat <- matrix(c("ab", "cd", "ef", "gh"), nrow = 2)
  
  expect_error(ensure_packages(mat), "'pkgs' is not a vector")
  expect_error(ensure_packages(9), "Invalid input")
  expect_error(ensure_packages(TRUE), "Invalid input")
  expect_error(ensure_packages(as.name("pack")), "Invalid input")
})

context("Data preprocessing")

test_that("Non-humanly readable characters are removed", {
  expect_that(remove_nonreadables(), gives_warning("No text data"))
  expect_that(remove_nonreadables(utfstr), equals("Missed my people"))
  expect_that(remove_nonreadables(6), equals("6"))
  expect_that(remove_nonreadables(1e07), is_a("character"))
  expect_that(remove_nonreadables(1e10), equals("1e+10"))
  expect_that(remove_nonreadables(TRUE), is_a("character"))
})

context("Sentiment analysis")

test_that("Emotional valence is computed", {
  expect_equal(class(compute_emotional_valence(txt)), "list")
  expect_equal(typeof(compute_emotional_valence(txt)), "list")
  expect_equal(length(compute_emotional_valence(txt)), length(txt))
})

test_that("Positive/negative words are tabulated", {
  expect_equal(class(make_word_table(result)), "list")
  expect_output(str(make_word_table(result)), "List of 2")
})

test_that("Volatile corpora are created", {
  expect_equal(class(make_corpus(txt)), c("VCorpus", "Corpus"))
  expect_output(str(make_corpus(txt)), "List of 3")
})

test_that("Correct platform is identified regardless of text case used", {
  expect_equal(choose_platform("TWItTEr"), 1)
  expect_equal(choose_platform("FACebOOk"), 2)
  expect_error(choose_platform("Others"), "Provide a supported")
})