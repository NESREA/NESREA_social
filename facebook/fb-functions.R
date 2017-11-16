## fb-functions.R
## User-defined functions to help work with Facebook API

library(Rfacebook)

# ..............................................................
## chooseInsight()
## Retrieves and preprocesses insights from NESREA Facebook Page
# ``````````````````````````````````````````````````````````````
## This is a wrapper for Rfacebook::getInsights()
chooseInsight <- function(type = c(
  "page_fan_adds",
  "page_fan_removes",
  "page_views_login",
  "page_views_logout",
  "page_views",
  "page_story_adds",
  "page_impressions",
  "page_posts_impressions",
  "page_consumptions",
  "post_consumptions_by_type",
  "page_fans_country"
)) {
  result <- getInsights(
    object_id = NESREA_page_id,
    token = nesreaToken,
    metric = type,
    version = API_version
  ) %>%
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
  cnames <-
    c(
      "from_id",
      "from_name",
      "message",
      "created_time",
      "type",
      "link",
      "id",
      "story",
      "likes_count",
      "comments_count",
      "shares_count"
    )
  
  if (!identical(colnames(df), cnames))
    stop("Loaded data are not compatible with this function")
  
   df$message <- df$message %>%
    gsub("[^[:graph:]]", " ", .) %>%
    str_trim(.)
  
  df$type <- as.factor(df$type)
  
  df$created_time <- df$created_time %>%
    gsub("T", " ", .) %>%
    gsub("\\+", " \\+", .) %>%
    as.POSIXct(.)
  df
}

# ....................................
## Collect data frame of post details
# ````````````````````````````````````
## conn - an SQLite database connection
## data - a dataframe returned by Rfacebook::getPage()
store_post_details <- function(conn, data = data.frame()) {
  ## Pick an ID and use it to download details related to a particular post
  cat(paste0("** Obtaining details for individual posts\n"))
  
  sapply(data$id, function(ID) {
    ## Download details for an individual post
    post_details <- getPost(post = ID, token = nesreaToken)
    
    ## Names of tables in the database
    local.tables <-
      c("nesreanigeria_fblikes", "nesreanigeria_fbcomments")
    
    sapply(local.tables, function(tb_name) {
      abbr <- substr(tb_name,
                     regexpr("fb", tb_name, ignore.case = TRUE) + 2,
                     nchar(tb_name))
      
      ## Collect data frame; add a column for post ID
      detail_df <- post_details[[abbr]] %>%
        mutate(post_id = ID)
      
      ## Append the new data to the local table
      dbWriteTable(conn, tb_name, detail_df, append = TRUE)
    })
  })
}
