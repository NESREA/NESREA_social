## downloadfunctions-gen.R

## Checks for packages and installs if missing.
## For new R installations, this check is absolutely necessary
ensure_packages <- function(pkgs = character()) {
  invisible(sapply(pkgs, function(x) {
    if (suppressPackageStartupMessages(
      !require(x, character.only = TRUE, quietly = TRUE))) {
      sprintf("Attempt download and installation of %s...", x)
      install.packages(x, repos = "https://cran.rstudio.com", verbose = FALSE)
      suppressPackageStartupMessages(library(x, character.only = TRUE))
      cat("DONE\n")
    } else {
      cat("All required packages are already installed\n")
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