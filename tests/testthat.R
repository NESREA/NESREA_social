library(testthat)

source("build/global-function-prototypes.R")
load("tests/testobj.RData")
source("build/test-build.R")

test_file("build/test-build.R")



# test_dir("build")
# test_dir("twitter")
# test_dir("facebook")
# test_dir("data")
