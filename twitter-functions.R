# Some Twitter functions for quick one-off operations

# Registers OAuth for a new session
# ````````````````````````````````
regOAuth <- function() {
  load("data/key.RData", envir = globalenv())
  setup_twitter_oauth(consumer_key = consumer_key,
                      consumer_secret = consumer_secret,
                      access_token = access_token,
                      access_secret = access_secret)
  rm(consumer_key, consumer_secret, access_secret, access_token,
     envir = globalenv())
}


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

# Updates NESREA database
# ```````````````````````
updateDB <- function() {
  register_sqlite_backend("data/nesreanigeria.db")
  n <- search_twitter_and_store("nesreanigeria", "nesreanigeria_tweets")
  cat(sprintf(ngettext(n, "%d tweet loaded.", "%d tweets loaded."), n))
}
