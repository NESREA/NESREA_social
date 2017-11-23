## download-nesrea-fbposts.R

## Obtain the data on individual Facebook Page posts
## NB: Admin role required!

## Prep
pkgs <- c("DBI", "RSQLite", "Rfacebook", "dplyr", "stringr")
suppressPackageStartupMessages(lapply(pkgs, library, character.only = TRUE))

source("facebook/fb-functions.R")
load("facebook/NESREA_fboauth")    # load 'nesreaToken'

## Set up database connections
sql.conn <- dbConnect(SQLite(), "data/nesreanigeria.db")

if (dbIsValid(sql.conn)) {
  cat("*** Database successfully connected\n")
} else {
  cat("*** There was a problem connecting to the database\n")
}

## Get all Page posts from Newsfeed
cat("*** Downloading Page posts from the Newsfeed\n")
posts <-
  getPage(page = "nesreanigeria",
          nesreaToken,
          n = 100,
          feed = TRUE)
dbWriteTable(sql.conn, "nesreanigeria_fbposts", posts, overwrite = TRUE)
cat("-- from Newsfeed were stored")

store_post_details(sql.conn, posts)

cat("\n** Checking for duplications\n")

tbls <- dbListTables(sql.conn) %>%
  subset(grepl("fb", .))

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
