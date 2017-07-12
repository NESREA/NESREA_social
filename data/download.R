# download.R

    ##########################################################
    ##  Download social media data through respective APIs  ##
    ##########################################################

                  ## - TWITTER - ##
# Search twitter.com for tweets containing the term 'nesreanigeria';
# then download them and store them locally in a database file.
# The intention is 'knit' the Rmarkdown document without having
# to go online at the time of preparing the report.
library(twitteR)

load("data/key.RData")
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
search_twitter_and_store(searchString = "nesreanigeria",
                         table_name = "nesreanigeria_tweets")
