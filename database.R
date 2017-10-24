# database.R
# Analyses on stored social media data

library(twitteR)
library(ggplot2)

tables <- 
  dbListTables(register_sqlite_backend("data/nesreanigeria.db"))
tables

tweetdata <- load_tweets_db(as.data.frame = TRUE,
                            table_name = tables[1])

# Exploratory analysis
str(tweetdata)
colnames(tweetdata)
adjust_tweetdata <- 
  dplyr::select(tweetdata, c(text:created, replyToUID:retweeted))
summary(adjust_tweetdata)
number_of_tweets <- nrow(tweetdata)
format(range(tweetdata$created), "%d %b %m %Y")
