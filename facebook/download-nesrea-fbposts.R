## download-nesrea-fbposts.R

library(Rfacebook)
library(dplyr)
library(stringr)

invisible(
  sapply(c("facebook/fb-functions.R", "facebook/fb_auth.R"), source)
)

## Insights on NESREA Page
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
  select(c(message:shares_count))

colnames(page_posts) <- gsub("_count$|_time$", "", colnames(page_posts))

page_posts$message <- page_posts$message %>%
  gsub("[^[:graph:]]", " ", .) %>%
  str_trim(.)

page_posts$type <- as.factor(page_posts$type)

page_posts$created <- substr(page_posts$created, start = 1,
                        stop = regexpr("T", page_posts$created) - 1)
page_posts

## Get full details of each Facebook Page post
## - Iterate through the data frame of Page posts, using 'id' as identifier
##   and download the relevant details per post and store in a list on disk.
rdsfile <- "facebook/nesrea-post-details.rds"
if (!file.exists(rdsfile)) {
  cat("* Harvesting details on Facebook page posts\n")
  post_details <- lapply(page_posts$id, getPost, nesreaToken)
  cat("** Data on individual page posts successfully downloaded\n")
  saveRDS(post_details, file = rdsfile)
  cat("** Details of individual page posts stored in the file",
      sQuote(basename(rdsfile)), "\n")
}
