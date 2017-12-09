## download-nesrea-fbposts.R

## Obtain the data on individual Facebook Page posts
## NB: Admin role required!
setwd(file.path(rootDir, "facebook/"))

## Prep
pkgs <- c("DBI", "RSQLite", "Rfacebook", "dplyr", "stringr")
ensure_packages(pkgs = pkgs)

## Load required objects (functions + 'nesreaToken') into the Workspace
source("fb-functions.R")
load("NESREA_fboauth")

## Oya, get busy...
cat("** Connecting the database")
sql.conn <- dbConnect(SQLite(), file.path(rootDir, "data/nesreanigeria.db"))
if (dbIsValid(sql.conn)) {
  cat(".....Done.\n")
} else {
  stop("There was a problem connecting to the database\n")
}

cat("** Downloading Page posts from the Newsfeed\n")
posts <-
  getPage(page = "nesreanigeria",
          nesreaToken,
          n = 200,
          feed = TRUE)
dbWriteTable(sql.conn, "nesreanigeria_fbposts", posts, overwrite = TRUE)
cat("-- from Newsfeed were stored")

store_post_details(sql.conn, posts)

cat("** Checking for and correcting duplications")
tbls <- dbListTables(sql.conn) %>%
  subset(grepl("fb", .))

sapply(tbls, function(x) {
  temp <- dbReadTable(sql.conn, x) %>%
    distinct(.)
  dbWriteTable(sql.conn, x, temp, overwrite = TRUE)
})
cat(".....Done.\n")

cat("** Disconnecting the database")
dbDisconnect(sql.conn)
if (!dbIsValid(sql.conn)) {
  cat("....Done.\n")
  rm(sql.conn)
} else {
  warning("The database could not be properly disconnected.")
}
rm(tbls, posts)

## Go back one step...
setwd("../")