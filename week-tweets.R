# week-tweets.R
# To download and store the tweets of the week in a dataframe object
library(twitteR)
consumer_key <- "x7TKjWEt0jYhgnZptAt9COKRL"
consumer_secret <- "q5LWFSHu2of2and7a1vl0dLGpez03bU5qvXpkbX2NklZJt4f4r"
access_token <- "742691184267677696-2HZMvozNMdt5qIqZjR9FLZJ0ctDUiEs"
access_secret <- "qB58UlnMDQfpqAhDHHvTpxEVwmANzJXfowb6lJNm7Cyyl"

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
tweets_list <- searchTwitter("nesreanigeria", n = 100, since = "2016-09-01")
tweets_df <- twListToDF(tweets_list)
saveRDS(tweets_df, "week-tweets.rds")
