## downloadfunctions-gen.R

## Checks for packages and installs if missing.
## For new R installations, this check is absolutely necessary
ensure_packages <- function(pkgs = character()) {
  invisible(sapply(pkgs, function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, repos = "https://cran.rstudio.com")
      suppressPackageStartupMessages(library(x, character.only = TRUE))
    }
  }))
}

## Ensures pre-existing database file or creates one in
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