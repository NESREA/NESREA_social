## download-nesrea-tweets.R
## Update NESREA database

setwd(file.path(rootDir, "twitter/"))

library(twitteR)
source("tw-functions.R")

logon_to_twitter()

update_nesrea_db()
