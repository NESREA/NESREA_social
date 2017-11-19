## download-nesrea-tweets.R
## Update NESREA database
library(twitteR)
source("twitter/tw-functions.R")

logon_to_twitter()

update_nesrea_db()
