# facebook-general.R

library(Rfacebook)
library(dplyr)
library(stringr)

NESREA_page_id <- "145175075891647"
NESREA_token <- readRDS("NESREA_fb_oauth.rds")
API_version <- "2.8"

# Insights on NESREA Page
insights <- getInsights(object_id = NESREA_page_id, token = NESREA_token,
            metric = "page_impressions", version = API_version)

core_insights <- select(insights, value:end_time)
core_insights$end_time <- substr(core_insights$end_time, start = 1,
         stop = regexpr("T", insights$end_time) - 1)
core_insights

# PUblic posts
page_posts <- getPage(page = "nesreanigeria", token = NESREA_token, feed = TRUE) %>%
  select(., c(message:type, likes_count:shares_count))
colnames(page_posts) <- gsub("_count$|_time$", "", colnames(page_posts))
page_posts$message <- page_posts$message %>%
  gsub("[[^:graph:]]", "", .) %>%
  str_trim(.)
page_posts$type <- as.factor(page_posts$type)
page_posts$created <- substr(page_posts$created, start = 1,
                        stop = regexpr("T", page_posts$created) - 1)
page_posts