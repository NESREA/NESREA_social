# Comparative analysis of Twitter activity

                 ##############################################
                 #          PRELIMINARIES/SETUP               #
                 ##############################################
library(twitteR)
library(magrittr)
                 
source("twitter/tw-functions.R")
check_wd()
logon_to_twitter()


                ##############################################
                #             ANALYSIS PROPER                #
                ##############################################
# Start with the small fry
handles <- c("@nesreanigeria", "@nosdra", "@biosafetyng")
result <- compare_mentions(handles)
# result <- result %>%
#   sapply(length) %>%
#   as.table(.)

chart(result)

# Add FMEnv
handles <- c(handles, "@FMENVNg")
result2 <- compare_mentions(handles)
# result2 <- result2 %>%
#   sapply(length) %>%
#   as.table(.)

chart(result2)

# Optionally increase the download limit, where one of the terms hits maximum
chart(compare_mentions(handles, n = 200))
chart(compare_mentions(handles, n = 500))
