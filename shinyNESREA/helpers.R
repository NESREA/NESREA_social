# helpers.R
source("authentication.R")
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
#   - if file exists, append
#   - else create new file and write
#   - Greeting message
#     - Version info - R, twitteR, Machine, API, ...
#     - Session info - date, time, location, IP, ...
#
# - Load existing data into the workspace
#   - make sure it's a valid dataframe
#   - get starting dimensions and enter into the log file
# - Download using search_twitter_and_store()
register_sqlite_backend(
  "~/7-NESREA/SA/WMG/NESREA_social/shinyNESREA/nesreanigeria.db")
twtnum <- 
  search_twitter_and_store("nesreanigeria", table_name = "nesreanigeria_tweets")

# - To load data for offline use:
## load_tweets_db(as.data.frame = TRUE, "nesreanigeria_tweets")

# - Look for duplicate records and fix
# - Get final dimensions and enter into the log file

# - End Session
#   - Record termination info
#   - Compute and document changes

# - Close the log file