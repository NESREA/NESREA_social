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
    stringr::str_trim(.)
  
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
  ## This function takes a while, so it's good to keep user abreast on progress
  ## Set up variables as much as possible to reduce indexing computations
  cat(paste0("\n*** Obtaining details for individual posts\n"))
  len <- length(data$id)
  PB <- txtProgressBar(max = len, style = 3, char = "-")
  
  for (i in 1:len) {
    post_IDs <- data$id
    ID <- post_IDs[i]
    
    post_details <- getPost(post = ID, token = nesreaToken)
    
    ## Names of tables of interest in the local database
    local.tables <-
      c("nesreanigeria_fblikes", "nesreanigeria_fbcomments")
    
    sapply(local.tables, function(tb_name) {
      
      ## Extract the string 'like' or 'comments' from the table names 
      abbr <- substr(tb_name,
                     regexpr("fb", tb_name, ignore.case = TRUE) + 2,
                     nchar(tb_name))
      
      ## Some posts e.g. 'Events', do not come in desired format,
      ## so there's a need to condition on that possibility
      if (abbr %in% names(post_details)) {
        
        ## Collect data frame; add a column for post ID
        detail_df <- post_details[[abbr]] %>%
          mutate(post_id = ID)
        
        ## Append the new data to the existing local table
        ## or create a brand new table if first-time use
        dbWriteTable(conn, tb_name, detail_df, append = TRUE)
      }
    })
    
    setTxtProgressBar(PB, i)   # increment the progress bar
  }
}
