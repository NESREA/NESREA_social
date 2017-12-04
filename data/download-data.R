## download-data.R

source("data/downloadfunctions-gen.R")
ensure_packages(c("DBI", "RSQLite"))

## Adjust the working directory
rootDir <- getwd()
setwd(file.path(rootDir, "data"))

## Confirm availability of database
validate_db("nesreanigeria.db")

## Download data from Twitter and Facebook, respectively
## Print appropriate messages.
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
