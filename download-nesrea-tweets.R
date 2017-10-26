# Update NESREA database
packrat::off()

library(twitteR)
source("twitter-functions.R")

logon_to_twitter()

update_nesrea_db()
