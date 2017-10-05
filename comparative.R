# Comparative analysis of Twitter activity

                 ##############################################
                 #          PRELIMINARIES/SETUP               #
                 ##############################################
library(twitteR)
source("twitter-functions.R")
check_wd()
logon_to_twitter()


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
