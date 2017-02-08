# helpers.R
# Helper functions and backend capabilities
# ===============================================================================

# make a corpus

make_corpus <- function(GText, stem = TRUE) {
  corp <- VCorpus(VectorSource(GText)) %>% # Put the text into tm format
    tm_map(removePunctuation) %>%
    tm_map(stripWhitespace) %>%
    tm_map(content_transformer(tolower)) %>%
    tm_map(removeWords, stopwords("english")) # remove meaningless words
  if(stem)
    corp <- tm_map(corp, stemDocument) # make verb & adjective, plural & singular, etc. forms identical
  
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
library(DBI)
source("authentication.R")

# create session log
log_connect <- file("data/log.txt")
open(log_connect, "w")
writeLines("SESSION LOG", log_connect)
writeLines(paste("Session Time:", format(Sys.time(), "%a %d %b %Y, %H:%M:%S")),
           log_connect)

# Version info
writeLines(R.version.string, log_connect)
if (any(grepl("rstudio", search()))) {
  writeLines(paste("RStudio version:", RStudio.Version()$version), log_connect)
  writeLines(paste("Mode of access:", RStudio.Version()$mode), log_connect)
  }
writeLines(paste("twitteR version:", as.character(packageVersion("twitteR"))),
           log_connect)
writeLines("Networking:", log_connect)
ip_add <- system("ipconfig", intern = TRUE)
writeLines(ip_add[grep("IPv4", ip_add)], log_connect)

# Download, store and quantify tweets     
register_sqlite_backend(
  "~/7-NESREA/SA/WMG/NESREA_social/shinyNESREA/data/nesreanigeria.db") #check...
twtnum <- 
  search_twitter_and_store("nesreanigeria", table_name = "nesreanigeria_tweets")
twtnum_all <- nrow(load_tweets_db(as.data.frame = TRUE, "nesreanigeria_tweets"))

writeLines(paste("Number of tweets downloaded:", twtnum), log_connect)
writeLines(paste("Total number of tweets in database:", twtnum_all), log_connect)
writeLines(paste("Current size of tweet database:",
                 file.info("data/nesreanigeria.db")$size, "B"), log_connect)
close(log_connect)

#db <- dbConnect(SQLite(), "shinyNESREA/data/nesreanigeria.db")
#result <- dbSendQuery(db, 'SELECT * FROM nesreanigeria_tweets')
#twtnum_all <- dbGetRowCount(result)
#dbDisconnect(db)

# - Load existing data into the workspace as a dataframe
## load_tweets_db(as.data.frame = TRUE, "nesreanigeria_tweets")
#   - get starting dimensions and enter into the log file

