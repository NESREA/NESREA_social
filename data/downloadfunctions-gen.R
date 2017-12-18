## downloadfunctions-gen.R

## Checks for packages and installs if missing.
## For new R installations, this check is absolutely necessary
ensure_packages <- function(pkgs) {
  if (length(dim(pkgs)) >= 2)
    stop("'pkgs' is not a vector.")
  if (!is.character(pkgs))
    stop("Invalid input - expected a character vector")
  invisible(sapply(pkgs, function(x) {
    if (suppressPackageStartupMessages(!require(x, character.only = TRUE))) {
      sprintf("Attempt download and installation of %s... ", x)
      install.packages(x, repos = "https://cran.rstudio.com", verbose = FALSE)
      suppressPackageStartupMessages(library(x, character.only = TRUE))
      if (x %in% (.packages(all.available = TRUE)))
        cat("Successful\n")
      else
        stop(sQuote(x), " installation failed.")
    }
  }))
}

## Ensures pre-existing database file or creates one in
## its absence (candidate for project parameterization)
validate_db <- function(dBase) {
  if (!file.exists(dBase)) {
    cat("Creating the database... ")
    con <- dbConnect(SQLite(), dBase)
    if (dbIsValid(con) && file.exists(dBase)) {
      cat("Done\n")
      dbDisconnect(con)
    } else {
      stop("The database could not be created")
    }
  }
}