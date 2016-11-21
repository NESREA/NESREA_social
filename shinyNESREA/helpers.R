# helpers.R
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

## Algorithm to collect and compile data from the Twitter API
# - Open log file
#   - Greeting message
#     - Version info - R, twitteR, Machine, API, ...
#     - Session info - date, time, location, IP, ...
# - Load existing data into the workspace
#   - make sure it's a valid dataframe
#   - get starting dimensions and enter into the log file
# - Download using searchTwitter()
# - Convert into a dataframe
# - Add to the existing dataframe
# - Look for repetitions
# - Delete the repetitions
# - Get final dimensions and enter in log file
# - Save the data as file
# - End Session
#   - Record termination info
#   - Compute and document changes
# - Close log file