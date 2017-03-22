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


################################################################
#                                                              #
#    Checking whether there is enough location-based data      #
#                                                              #
################################################################

# load the data from disk
twitteR::register_sqlite_backend("shinyNESREA/data/nesreanigeria.db")
dataset <- twitteR::load_tweets_db(as.data.frame = TRUE,
                                   table_name = "nesreanigeria_tweets")

colnames(dataset)     # checking for relevant variables

all(is.na(dataset$longitude))     # are they all NA?

targetIndex <- which(!is.na(dataset$longitude))  # which ones are not NAs?
length(targetIndex)
targetIndex

# extract tweet with geolocation data
dataset$longitude[targetIndex]
dataset[targetIndex, ]
View(dataset[targetIndex, ])

# Proportion of dataset that has geolocation data
proportion <- length(dataset$longitude[targetIndex]) / nrow(dataset)
proportion 
paste0(round(proportion * 100, 2), "%")
#END
