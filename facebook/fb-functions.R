## fb-functions.R
## User-defined functions to help work with Facebook API

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
  cat("Obtaining details for individual posts\n")
  len <- length(data$id)
  PB <- txtProgressBar(max = len,
                       style = 3,
                       char = "-")
  
  for (i in 1:len) {
    post_IDs <- data$id
    ID <- post_IDs[i]
    
    post_details <-
      getPost(post = ID,
              n = 1000,
              token = nesreaToken)
    
    
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
  cat("\n")
}

# ....................................................................
# Creates an S3 object containing an access token and its expiry date
#
## The key thing about this function is that we want to be able to
## keep in store the expected expiry date the token according to the
## prevailing Facebook API policy, so that on loading it we can
## confirm whether it is still valid or not.
# ````````````````````````````````````````````````````````````````````
mytoken <- function(app_id, app_secret) {
  require(Rfacebook)
  token <-
    list(
      token = fbOAuth(app_id = app_id, app_secret = app_secret),
      expiryDate = Sys.Date() + 60
    )
  attr(token, "class") <- "mytoken"
  token
}

# ..........................................................................
# fetch_token()
#
## Checks for local storage of the access token. If it is already present
## we also check whether it has expired or not, in line with Facebook's
## policy on token changes. The App credentials used (App Id & App Secret)
## are as available via the App dashboard,
# ``````````````````````````````````````````````````````````````````````````
fetch_token <- function(file, app_id, app_secret) {
  if (file.exists(file))
    load(file, verbose = TRUE)
  
  if (!file.exists(file) | nesreaToken$expiryDate <= Sys.Date()) {
    nesreaToken <- mytoken(app_id, app_secret)
    save(nesreaToken, file = as.character(file))
  }
  
  ## Redefine object since we're done using the date element
  Tk <- nesreaToken$token
}
