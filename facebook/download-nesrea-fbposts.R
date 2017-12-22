## download-nesrea-fbposts.R

## Obtain the data on individual Facebook Page posts
## NB: Admin role required!
setwd(file.path(rootDir, "facebook/"))

## Preparations
pkgs <- c("DBI", "RSQLite", "Rfacebook", "dplyr", "stringr")
ensure_packages(pkgs = pkgs)

## Load required functions
source("fb-functions.R")

## Check if access token is still valid
## This file contains secret credentials and hence is not shared publicly
## At the end of the file, an access token, aongst others, is loaded
## into the workpace
source("fb_auth.R")

## Oya, get busy...
cat("Connecting the database... ")
sql.conn <- dbConnect(SQLite(), file.path(rootDir, "data/nesreanigeria.db"))
if (dbIsValid(sql.conn)) {
  cat("DONE\n")
} else {
  stop("There was a problem connecting to the database\n")
}

cat("Downloading Page posts from the Newsfeed\n")
posts <-
  getPage(page = "nesreanigeria",
          nesreaToken,
          n = 200,
          feed = TRUE)
dbWriteTable(sql.conn, "nesreanigeria_fbposts", posts, overwrite = TRUE)
cat("from Newsfeed were stored\n")

store_post_details(sql.conn, posts)

cat("Checking for and correcting duplications... ")
tbls <- dbListTables(sql.conn) %>%
  subset(grepl("fb", .))

sapply(tbls, function(x) {
  temp <- dbReadTable(sql.conn, x) %>%
    distinct(.)
  dbWriteTable(sql.conn, x, temp, overwrite = TRUE)
})
cat("DONE\n")

cat("Disconnecting the database... ")
dbDisconnect(sql.conn)
if (!dbIsValid(sql.conn)) {
  cat("DONE\n")
  rm(sql.conn)
} else {
  warning("The database could not be properly disconnected.")
}
rm(tbls, posts)

## Go back one step...
setwd("../")
