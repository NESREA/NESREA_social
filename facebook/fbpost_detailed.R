## fbpost_detailed.R

## Obtain the details for individual Facebook Page posts
## NB: Admin role required!

library(DBI)
library(RSQLite)
library(dplyr)
library(Rfacebook)

source("facebook/fb-functions.R")
load("facebook/NESREA_fboauth")

## Begin
cat("* Updating local Facebook data\n")

## Set up database connections
sql.conn <- dbConnect(SQLite(), "data/nesreanigeria.db")

if (dbIsValid(sql.conn)) {
  cat("** Database successfully connected\n")
} else {
  cat("** There was a problem connecting to the database\n")
}

## Get all Page posts from Newsfeed
cat("Downloading Page posts from the Newsfeed")
posts <-
  getPage(page = "nesreanigeria",
          nesreaToken,
          n = 100,
          feed = TRUE)

store_post_details(sql.conn, posts)

cat("** Checking for duplications\n")

tbls <- dbListTables(sql.conn)
tbls <- tbls[grepl("fb", tbls)]

sapply(tbls, function(x) {
  temp <- dbReadTable(sql.conn, x) %>%
    distinct(.)
  dbWriteTable(sql.conn, x, temp, overwrite = TRUE)
})

## Disconnect and clean up
dbDisconnect(sql.conn)

if (!dbIsValid(sql.conn)) {
  cat("** Database successfully disconnected\n")
  rm(sql.conn, tbls, posts)
}

## Goodbye
cat("* Updates to local Facebook data completed\n")
