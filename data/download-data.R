## download-data.R

if (!interactive())
  rootDir <- getwd()

setwd(file.path(rootDir, "data"))

## Ensures pre-existing database file or create one in
## its absence (candidate for project parameterization)
validate_db <- function(dBase) {
  requireNamespace("DBI", quietly = TRUE)
  requireNamespace("RSQLite", quietly = TRUE)
  if (!file.exists(dBase)) {
    cat("* Creating the database\n")
    con <- dbConnect(SQLite(), dBase)
    if (dbIsValid(con) && file.exists(dBase)) {
      cat("** Done\n")
      dbDisconnect(con)
    } else {
      stop("The database could not be created")
    }
  }
}

validate_db("nesreanigeria.db")

tw <- "Twitter"
fb <- "Facebook"
beg <- "* Starting %s downloads\n"
end <- "downloads completed\n"

cat(sprintf(beg, tw))
source(file.path(rootDir, "twitter/download-nesrea-tweets.R"))
cat("*", tw, end)

cat(sprintf(beg, fb))
source(file.path(rootDir, "facebook/download-nesrea-fbposts.R"))
cat("*", fb, end)

rm(tw, fb, beg, end)
