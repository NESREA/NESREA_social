# Some Twitter functions for quick one-off operations

# .....................................
# Collects tweets to a maximum of 1,000
# `````````````````````````````````````
collect_tweets <- function(string = character())
{
  if (!is.character(string))
    stop("'string' is not a character vector")
  if (length(string) > 1) {
    string <- string[1]
    warning("Only the first term was used. The rest was ignored.")
  }
  if (nchar(string) < 3 | nchar(string) > 20)
    stop("A term of between 3 and 20 characters is required.")
  twt <- twitteR::searchTwitter(string, n = 1000)
  twt <- twitteR::twListToDF(twt)
}

# .................................
# Displays a density plot of tweets
# `````````````````````````````````
display_twts <- function(x)
{
  if (!suppressPackageStartupMessages(require(ggplot2)))
    stop("package ggplot2 is missing. Run install.packages(\"ggplot2\")")
  if (!is.data.frame(x))
    stop("x is not a data frame")
  tgt <- c("created", "isRetweet")
  if (!identical(match(tgt, colnames(x)), as.integer(c(5, 13))))
    stop("Not a valid tweet data frame.")
  if (!(is.POSIXct(x$created) & is.logical(x$isRetweet)))
    stop("The data do not match the type required for the analysis.")
  plot <- ggplot(x, aes(created)) +
    geom_density(aes(fill = isRetweet), alpha = 0.7) +
    theme(legend.justification = c(1, 1), legend.position = c(1, 1)) +
    xlab("All tweets")
  plot
}

# .......................
# Updates NESREA database
# ```````````````````````
update_nesrea_db <- function() {
  register_sqlite_backend("data/nesreanigeria.db")
  n <- search_twitter_and_store("nesreanigeria", "nesreanigeria_tweets")
  cat(sprintf(ngettext(n, "%d tweet loaded.", "%d tweets loaded."), n))
}

# ...........................................................
# Searches and displays tweet(s) containing a particular word
# ```````````````````````````````````````````````````````````
show_tweets_containing_word <- function(word = character(), df = wk_data) {
    if (!is.character(word))
      stop("Expected a string as input")
    if (length(word > 1)) {
      word <- word[1]
      warning("First element of 'word' used; the rest was discarded.")
    }
    
    index <- grepl(word, df$text, fixed = TRUE)
    if (any(index)) {
      success <- df$text[index]
      print(success)
    } else { cat("Word not found") }
}

# ..................
# compare_mentions()
# ``````````````````
# Prints a proportions table of number of tweets for various search terms
## Parameters: x - character vector of search terms
##             n - max. number of tweets to download (default is 50)  

compare_mentions <- function(x, n = 50L) {
  require(magrittr)
  if (!is.character(x))
    stop("'x' is not a character vector.")
  if (!is.atomic(x))
    stop("'x': Expected an atomic vector.")
  if (is.numeric(n))
    n <- as.integer(n)
  if (!is.integer(n))
    stop("'n' is not an integer type.")
  twtNum <- sapply(x, function(term) {
    dat <- suppressWarnings(searchTwitter(term, n))
    # # len <- length(dat)
    # if (length(dat) == n) {
    #   warning("Max. number of tweets downloaded for ", sQuote(trm),
    #                  ".\nYou may want to extend the download limit beyond ",
    #                  n,
    #                  ".")
    # }
    # attr(len, which = "max") <- n
    # len
    }) %>%
    sapply(length) %>%
    as.table(.)
}

# .......
# chart()
# ```````
## Generates a barplot that compares the propotion of tweets with differnt
## search terms, colours it and gives it appropriate labels
## Parameters: tbl - object returned by compare_mentions()

chart <- function(tbl) {
  if (!is.table(tbl))
    stop("Argument is not a table.")
  barplot(tbl, col = "brown", main = "Comparative barplot of tweets")
}

# ..............................................
# Checks/reminds correct working directory usage
# ``````````````````````````````````````````````
check_wd <- function() {
  MyComputer <- Sys.info()["nodename"]
  workdir <- "~/Documents/7-NESREA/SA/WMG/NESREA_social/"
  if (MyComputer == "SA-DG" | MyComputer == "NESREA") {
    if (!identical(getwd(), path.expand(workdir)))
      setwd(workdir)
  } else { warning("Make sure to correctly set the working directory.") }
}

# ..............................................
# Logs on to Twitter API using Oauth credentials
# ``````````````````````````````````````````````
logon_to_twitter <- function() {
  keys <- "data/key.RData"
  if (!file.exists(keys)) {
    warning("You must supply OAuth credentials to proceed.")
  } else { load(keys, envir = globalenv()) }
  
  setup_twitter_oauth(consumer_key = consumer_key,
                      consumer_secret = consumer_secret,
                      access_token = access_token,
                      access_secret = access_secret)
  rm(consumer_key, consumer_secret, access_token, access_secret,
     envir = globalenv())
}
