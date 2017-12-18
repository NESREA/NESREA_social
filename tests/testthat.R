library(testthat)

library(DBI)
library(RSQLite)

## Load experimental objects into the Workspace
load("tests/testobj.RData")
exampleDotCom <- xml2::read_html("tests/example.xml")
conn <- dbConnect(SQLite(), "data/nesreanigeria.db")
tables <- dbListTables(conn)
dbDisconnect(conn)
srchpath <- search()

## Load functions into the Workspace
source("build/global-function-prototypes.R")
source("data/downloadfunctions-gen.R")
source("website/website-functions.R")

## LOad the test scripts into the Workspace
source("data/test-database.R")
source("build/test-build.R")
source("website/test-website.R")

## Run the tests
test_file("data/test-database.R")
test_file("build/test-build.R")
test_file("website/test-website.R")

rm(conn, tables, result, corp, txt, exampleDotCom)
