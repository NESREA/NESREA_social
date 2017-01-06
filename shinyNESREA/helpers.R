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

library(DBI)
source("shinyNESREA/authentication.R")

# - create/open log
if (file.exists("log.txt")) {
  conn <- file("log.txt")
  open(conn, "a")
} else {
  conn <- file("log.txt", "w")
  open(conn, "w")
}

# Version info
writeLines(R.version.string)
writeLines(paste("twitteR version:", as.character(packageVersion("twitteR"))))

# Session info
writeLines(paste("Date accessed:", format(Sys.time(), "%a %d %b %Y, %H:%M:%S")))
ip_add <- system("ipconfig"); writeLines(ip_add[grep("IPv4", ip_add)])

# - Download and store tweets          
register_sqlite_backend(
  "~/7-NESREA/SA/WMG/NESREA_social/shinyNESREA/nesreanigeria.db")
twtnum <- 
  search_twitter_and_store("nesreanigeria", table_name = "nesreanigeria_tweets")
db <- dbConnect(SQLite(), "nesreanigeria.db")
result <- dbSendQuery(db, 'SELECT * FROM nesreanigeria_tweets')
twtnum_all <- dbGetRowCount(result)

# - Load existing data into the workspace as a dataframe
## load_tweets_db(as.data.frame = TRUE, "nesreanigeria_tweets")
#   - get starting dimensions and enter into the log file

# Get final dimensions and enter into the log file
writeLines(paste("Today you stored", twtnum, "tweets"))

# - End Session
writeLines(paste("Session ended:", format(Sys.time(), "%H:%M:%S")))
close(conn)