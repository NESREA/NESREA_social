# focused-tweets.R
library(lubridate)
library(dplyr)
twitterData <- readRDS("week-tweets.rds")
dim(twitterData)

tweets_02 <- filter(twitterData, mday(created) == 2)
tweets_03 <- filter(twitterData, mday(created) == 3)
tweets_04 <- filter(twitterData, mday(created) == 4)
tweets_05 <- filter(twitterData, mday(created) == 5)

max(twitterData$retweetCount)
twitterData$text[which(twitterData$retweetCount == max(twitterData$retweetCount))]


tweets_07 <- filter(twitterData, mday(created) == 7)
tweets_07$text
