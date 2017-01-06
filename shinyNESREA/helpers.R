# helpers.R
library(DBI)
source("shinyNESREA/authentication.R")

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

# Define colours
color <- function() {
  require(RColorBrewer)
  col <- brewer.pal(3, 'Paired')
  col
}

## To collect and compile data from the Twitter API
# TODO
# - Open log file
if (file.exists("log.txt")) {
  conn <- file("log.txt")
  open(conn, "a")
} else {
  conn <- file("log.txt", "w")
  open(conn, "w")
}

#   - Message
#     - Version info - R, twitteR, Machine, API, ...
writeLines(R.version.string)
writeLines(paste("twitteR version:", as.character(packageVersion("twitteR"))))

#     - Session info - date, time, location, IP, ...
writeLines(paste("Date accessed:", format(Sys.time(), "%a %d %b %Y, %H:%M:%S")))
ip_add <- system("ipconfig"); writeLines(ip_add[grep("IPv4", ip_add)])

# - Download using search_twitter_and_store()           
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

# - Look for duplicate records and fix
# - Get final dimensions and enter into the log file
writeLines(paste("Today you stored", twtnum, "tweets"))


# - End Session
writeLines(paste("Session ended:", format(Sys.time(), "%H:%M:%S")))
close(conn)