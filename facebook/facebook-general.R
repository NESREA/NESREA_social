# facebook-general.R

library(Rfacebook)
library(dplyr)
library(stringr)

source("fb_authentication.R")    # contains credentials for accessing API data

# Insights on NESREA Page
# First of all, define a function to simplify our use of getInsights()
chooseInsight <- function(type = c("page_fan_adds", "page_fan_removes",
                              "page_views_login", "page_views_logout",
                              "page_views", "page_story_adds",
                              "page_impressions", "page_posts_imporessions",
                              "page_consumptions", "post_consumptions_by_type",
                              "page_fans_country")) {
  result <- getInsights(object_id = NESREA_page_id,
                        token = NESREA_token,
                        metric = type,
                        version = API_version)
  result <- select(result, value:end_time)
  result$end_time <- substr(result$end_time,
                            start = 1,
                            stop = regexpr("T", result$end_time) - 1)
  result 
}

newFans <- chooseInsight("page_fan_adds")
fansLeft <- chooseInsight("page_fan_removes")
pageViewsLogin <- chooseInsight("page_views_login")
pageViews <- chooseInsight("page_views")
newStories <- chooseInsight("page_story_adds")
pageImpressions <- chooseInsight("page_impressions")
postImpressions <- chooseInsight("page_posts_impressions")
pageConsumptions <- chooseInsight("page_consumptions")

# build a single dataframe from these objects
allInsights <- data.frame(newFans[, 1], fansLeft[, 1], pageViewsLogin[, 1],
                          pageViews[, 1], newStories[, 1], pageImpressions[, 1],
                          postImpressions[, 1], pageConsumptions[, 1],
                          endtime = pageConsumptions[, 2])
colnames(allInsights) <- gsub("[^[:alpha:]]", "", colnames(allInsights))
summary(allInsights)

# PUblic posts
page_posts <- getPage(page = "nesreanigeria",
                      token = NESREA_token, feed = TRUE) %>%
  select(., c(message:type, likes_count:shares_count))
colnames(page_posts) <- gsub("_count$|_time$", "", colnames(page_posts))
page_posts$message <- page_posts$message %>%
  gsub("[[^:graph:]]", "", .) %>%
  str_trim(.)
page_posts$type <- as.factor(page_posts$type)
page_posts$created <- substr(page_posts$created, start = 1,
                        stop = regexpr("T", page_posts$created) - 1)
page_posts
