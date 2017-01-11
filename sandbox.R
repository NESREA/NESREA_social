# Insights into an observed spike
# Date: Wed 11 Jan 2017; 14:35:33

head(tweets$created)
space_location <- regexpr(" ", tweets$created)
tweets$created <- substr(tweets$created, 0, space_location -1)
head(tweets$created)

any(tweets$created == "2017-01-10")

recentRTs <- tweets %>%
  filter(created == "2017-01-10") %>%
  filter(isRetweet == TRUE)
recentRTs


highestRTs <- max(recentRTs$retweetCount)
highestRTs
mostRTed <- which(recentRTs$retweetCount == highestRTs)
recentRTs$text[mostRTed]  # UNEP
