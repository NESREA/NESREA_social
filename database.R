# database.R
# Analyses on stored social media data

library(twitteR)

tables <- 
  DBI::dbListTables(register_sqlite_backend("data/nesreanigeria.db"))
cat(tables, "\n")

tweetdata <- load_tweets_db(as.data.frame = TRUE,
                            table_name = tables[1])

# Exploratory analysis
str(tweetdata)

adjust_tweetdata <- 
  dplyr::select(tweetdata, c(text:created, replyToUID:retweeted))
str(adjust_tweetdata)
print(summary(adjust_tweetdata))
number_of_tweets <- nrow(tweetdata)
first_to_last <- format(range(tweetdata$created), "%d %b %m %Y")
