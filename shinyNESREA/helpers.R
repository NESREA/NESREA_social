# helpers.R

# Objects
textOnLoadedTweets <- 
  "tweets were downloaded. Select a value to extend the download limit: "
textOnTweetsByPlatform <- 'Number of tweets posted by platform'




# Helper functions and backend capabilities
# ==============================================================================

# make a corpus
make_corpus <- function(GText, stem = TRUE) {
  corp <- VCorpus(VectorSource(GText)) %>% # Put the text into tm format
    tm_map(removePunctuation) %>%
    tm_map(stripWhitespace) %>%
    tm_map(content_transformer(tolower)) %>%
    tm_map(removeWords, stopwords("english")) # remove meaningless words
  if(stem)
    corp <- tm_map(corp, stemDocument) # verb/adj, plural/sing, etc, identical
  
  names(corp) <- names(GText)
  corp
}
# ==============================================================================

# Define colours

color <- function() {
  require(RColorBrewer)
  col <- brewer.pal(3, 'Paired')
  col
}
# ==============================================================================

## Collect and store Twitter data
library(twitteR)
source("authentication.R")

contentDataDirectory <- list.files(path = "data/", all.files = TRUE)

# Download, store and quantify tweets
if (!"nesreanigeria.db" %in% contentDataDirectory) {
  RSQLite::dbConnect(SQLite(), dbname = "data/nesreanigeria.db")
  message("New SQLite database file created")
  Sys.sleep(3)
}

register_sqlite_backend("data/nesreanigeria.db")
twtnum <- search_twitter_and_store("nesreanigeria",
                                   table_name = "nesreanigeria_tweets")
twtnum_all <- nrow(load_tweets_db(as.data.frame = TRUE, "nesreanigeria_tweets"))

# Create current session log
if (!"log.txt" %in% contentDataDirectory) {
  invisible(file.create("data/log.txt"))
  message("New log file created.")
  Sys.sleep(1)
}

log_connect <- file("data/log.txt")
open(log_connect, "w")

writeLines("SESSION LOG", log_connect)
writeLines(paste("Session Time:", format(Sys.time(), "%a %d %b %Y, %H:%M:%S")),
           log_connect)
writeLines(R.version.string, log_connect)   # Version info for R, packages, etc
if ("tools:rstudio" %in% search()) {
  writeLines(paste("RStudio version:", RStudio.Version()$version), log_connect)
  writeLines(paste("Mode of access:", RStudio.Version()$mode), log_connect)
  }
writeLines(paste("twitteR version:", as.character(packageVersion("twitteR"))),
           log_connect)
writeLines("Networking:", log_connect)
ip_add <- system("ipconfig", intern = TRUE)
writeLines(ip_add[grep("IPv4", ip_add)], log_connect)
writeLines(paste("Number of tweets added to database:", twtnum),
           log_connect)
writeLines(paste("Total number of tweets in database:", twtnum_all), log_connect)
writeLines(paste("Current size of tweet database:",
                 file.info("data/nesreanigeria.db")$size, "B"), log_connect)

close(log_connect)

# =============================================================================
# Plotting function for kernel density plots

plotDensity <- function(data = x, entry = character(), daily = FALSE) {
  if (daily)
    title <- paste0("Distribution of tweets mentioning \"",
                    entry,
                    "\" (Daily Results)")
  else title <- paste0("Distribution of tweets mentioning \"",
                       entry,
                       "\"")
  gg <- ggplot2::ggplot(data, aes(created)) +
    geom_density(aes(fill = isRetweet), alpha = .7) +
    theme(legend.justification = c(1, 1), legend.position = c(1, 1)) +
    ggtitle(title) +
    xlab("Date")
  gg
}
# ==============================================================================
# Process the data frame to obtain list of positive/negative words
createWordList <- function(x) {
  pwt <- sapply(x, function(p) {
    words = c(positiveWords = paste(p[[1]]$pos.words[[1]], collapse = ' '),
              negativeWords = paste(p[[1]]$neg.words[[1]], collapse = ' '))
    gsub('-', '', words) # Get rid of nothing found's "-"
    }) %>%
    apply(1, paste, collapse = ' ') %>%
    stripWhitespace() %>%
    strsplit(' ') %>%
    sapply(table)
  pwt
}
# ==============================================================================
# processBagofwords()
processBagofWords <- function(x, table) {
  pt <- sapply(x, function(subdata) {
    paste(tolower(subdata$text), collapse = ' ') %>%
      gsub(' http|@)[^[:blank:]]+', '', .) %>%
      gsub('[[:punct:]]', '', .)
    }) %>%
    structure(names = c('negative', 'neutral', 'positive'))
  pt['negative'] <- removeWords(pt['negative'],
                                     names(table$negativeWords))
  pt['positive'] <- removeWords(pt['positive'],
                                     names(table$positiveWords))
  pt
}
# =============================================================================
# split data frame and prepare the main objects used for the various outputs
prepareObjects <- function(data) {
  spl <- split(data, data$isRetweet)
  main <- spl[['FALSE']]
  pol <- lapply(main$text, function(txt) {
    gsub("(\\.|!|\\?)+\\s+|(\\++)", " ", txt) %>%
      gsub(" http[^[:blank:]]+", "", .) %>%
      polarity(.)
  })
  value <- list(split = spl, original = main, polarity = pol)
  value
}