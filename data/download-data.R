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
wb <- "NESREA Website"
beg <- "Starting %s downloads\n"
end <- "downloads completed\n\n"

cat(sprintf(beg, tw))
source(file.path(rootDir, "twitter/download-nesrea-tweets.R"))
cat(tw, end)

cat(sprintf(beg, fb))
source(file.path(rootDir, "facebook/download-nesrea-fbposts.R"))
cat(fb, end)

cat(sprintf(beg, wb))
source(file.path(rootDir, "website/download-nesrea-website.R"))
cat(wb, end)

rm(tw, fb, wb, beg, end)
