## download-data.R

## For new R installations, this check is absolutely necessary
invisible(
  sapply(c("DBI", "RSQLite"), function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, repos = "https://cran.rstudio.com")
      library(x, character.only = TRUE)
    }
  })
)
rootDir <- getwd()
setwd(file.path(rootDir, "data"))

## Ensures pre-existing database file or create one in
## its absence (candidate for project parameterization)
validate_db <- function(dBase) {
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
