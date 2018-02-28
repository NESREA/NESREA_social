## download-nesrea-fbposts.R

## Obtain the data on individual Facebook Page posts
## NB: Admin role required!
ensure_packages(
  c("DBI", "RSQLite", "Rfacebook", "dplyr", "rprojroot", "stringr")
  )

## Load required functions
source(find_root_file("facebook", "fb-functions.R", criterion = rootCrit))

## Check if access token is still valid
## This file contains secret credentials and hence is not shared publicly
## At the end of the file, an access token, aongst others, is loaded
## into the workpace
source(find_root_file("facebook", "fb_auth.R", criterion = rootCrit))

## Let's go...
## TODO: Implement exception handling while DB is open
if (!is.null(nesreaToken)) {
  cat("Connecting the database... ")
  sql.conn <-
    dbConnect(SQLite(),
              find_root_file("data", "nesreanigeria.db", criterion = rootCrit))
  
  if (dbIsValid(sql.conn)) {
    cat("DONE\n")
  } else
    stop("There was a problem connecting to the database\n")
  
  cat("Downloading Page posts from the Newsfeed\n")
  posts <- getPage(page = "nesreanigeria",
                   nesreaToken,
                   n = 200,
                   feed = TRUE)
  dbWriteTable(sql.conn, "nesreanigeria_fbposts", posts, overwrite = TRUE)
  cat("from Newsfeed were stored\n")
  
  store_post_details(sql.conn, posts)
  
  cat("Checking for and correcting duplications... ")
  tbls <- dbListTables(sql.conn) %>%
    subset(grepl("fb", .))
  
  sapply(tbls, function(Tb) {
    temp <- dbReadTable(sql.conn, Tb) %>%
      distinct(.)
    
    dbWriteTable(sql.conn, Tb, temp, overwrite = TRUE)
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
}
rm(tbls, posts)
