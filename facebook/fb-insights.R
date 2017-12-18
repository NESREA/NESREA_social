## fb_insights.R

# Insights on NESREA Page -------------------------------------------------

insight.type <-
  c(
    "page_fan_adds",
    "page_fan_removes",
    "page_views_login",
    "page_views",
    "page_story_adds",
    "page_impressions",
    "page_posts_impressions",
    "page_consumptions"
  )

allInsights <-
  as.data.frame(lapply(insight.type, chooseInsight)) %>%
  select(matches("value|end_time.7")) %>%
  distinct(.)

colnames(allInsights)[1:8] <- gsub("^page_", "", insight.type)
colnames(allInsights)[9] <- "date"
allInsights$date <- as.Date(allInsights$date)
str(allInsights)
