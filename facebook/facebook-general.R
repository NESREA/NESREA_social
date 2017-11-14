## facebook-general.R

library(Rfacebook)
library(dplyr)
library(stringr)

source("facebook/fb_auth.R")  # file contains authentication credentials

## Insights on NESREA Page
## First of all, define a function to simplify our use of getInsights()
chooseInsight <- function(type = c("page_fan_adds",
                                   "page_fan_removes",
                                   "page_views_login",
                                   "page_views_logout",
                                   "page_views",
                                   "page_story_adds",
                                   "page_impressions",
                                   "page_posts_impressions",
                                   "page_consumptions",
                                   "post_consumptions_by_type",
                                   "page_fans_country")) {
  
  result <- getInsights(object_id = NESREA_page_id,
                        token = nesreaToken,
                        metric = type,
                        version = API_version) %>%
    select(value:end_time)
  result$end_time <- substr(result$end_time,
                            start = 1,
                            stop = regexpr("T", result$end_time) - 1)
  result 
}

insight.type <- c("page_fan_adds", "page_fan_removes", "page_views_login",
                  "page_views", "page_story_adds", "page_impressions",
                  "page_posts_impressions", "page_consumptions")

allInsights <- as.data.frame(lapply(insight.type, chooseInsight)) %>%
  select(matches("value|end_time.7")) %>%
  distinct(.)

colnames(allInsights)[1:8] <- gsub("^page_", "", insight.type)
colnames(allInsights)[9] <- "date"
allInsights$date <- as.Date(allInsights$date)
str(allInsights)

## PUblic posts
page_posts <- getPage(page = "nesreanigeria", n = 100,
                      token = nesreaToken, feed = TRUE) %>%
  select(c(message:type, likes_count:shares_count))
colnames(page_posts) <- gsub("_count$|_time$", "", colnames(page_posts))
page_posts$message <- page_posts$message %>%
  gsub("[^[:graph:]]", " ", .) %>%
  str_trim(.)
page_posts$type <- as.factor(page_posts$type)
page_posts$created <- substr(page_posts$created, start = 1,
                        stop = regexpr("T", page_posts$created) - 1)
page_posts
