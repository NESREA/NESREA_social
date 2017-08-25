# Comparative analysis of Twitter activity

                ##############################################
                #          CUSTOM FUNCTIONS                  #
                ##############################################
# 1. compare_mentions()
# Prints a table of number of tweets for various search terms
## Parameters: x - character vector of search terms
##             n - max. number of tweets to download (default is 50)               
compare_mentions <- function(x, n = 50) {
    twtNum <- sapply(x, function(trm) {
        
        ## Download tweets on a particlar term & obtain number
        dt <- suppressWarnings(searchTwitter(trm, n,
                                             since = as.character(Sys.Date() - 7)))
        len <- length(dt)
        if (len == n) {
            warning(paste0("Max. number of tweets downloaded for ",
                           sQuote(trm),
                           ".\nYou may want to extend the download limit beyond ",
                           n,
                           "."))
        }
        attr(len, which = "max") <- n
        len
    })
    names(twtNum) <- x
    prop.table(twtNum)
}

# 2. chart()
## Generates a barplot that compares the propotion of tweets with differnt
## search terms, colours it and gives it appropriate labels
## Parameters: tbl - object returned by compare_mentions()
chart <- function(tbl) {
    barplot(tbl,
            col = "brown",
            main = "Comparative barplot of tweets"
            )
}

                 ##############################################
                 #          PRELIMINARIES/SETUP               #
                 ##############################################
library(twitteR)

MyComputer <- Sys.info()["nodename"]

if (MyComputer == "SA-DG" | MyComputer == "NESREA") {
    setwd("~/7-NESREA/SA/WMG/NESREA_social/")
} else { warning("You may not have set your working directory yet.") }

# Log on to Twitter API
keys <- "data/key.RData"
if (!file.exists(keys)) {
    warning("You must supply OAuth credentials to proceed.")
} else {load(keys)}

setup_twitter_oauth(consumer_key = consumer_key,
                    consumer_secret = consumer_secret,
                    access_token = access_token,
                    access_secret = access_secret)
rm(list = ls())


                ##############################################
                #             ANALYSIS PROPER                #
                ##############################################
# Start with the small fry
mentions <- c("@nesreanigeria", "@nosdra", "@biosafetyng")
result <- compare_mentions(mentions)
result

chart(result)

# Add FMEnv
mentions <- c(mentions, "@FMENVNg")
result2 <- compare_mentions(mentions)
result2

chart(result2)

# Optionally increase the download limit, where one of the terms hits maximum
chart(compare_mentions(mentions, n = 200))
chart(compare_mentions(mentions, n = 500))
