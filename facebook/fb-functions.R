## fb-functions.R
## User-defined functions to help work with Facebook API


# ..............................................................
## chooseInsight()
## Retrieves and preprocesses insights from NESREA Facebook Page
# ``````````````````````````````````````````````````````````````
## This is a wrapper for Rfacebook::getInsights()
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

# ....................................................
## prepare_data(): Processes FB data prior to analysis
# ````````````````````````````````````````````````````
prepare_data <- function(df = data.frame()) {
  ## validate if the data frame is the kind we use
  cnames <- c("message", "created", "type", "link", "id", "story", "likes",
              "comments", "shares")
  if (!identical(colnames(df), cnames))
    stop("Loaded data are not compatible with this function")
  
  df$created <- as.Date(df$created)
  df$type <- as.factor(df$type)
  df
}