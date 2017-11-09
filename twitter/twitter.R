# NESREA Twitter Analysis
# Inspired by Michael Levy - http://michaellevy.name/blog/conference-twitter/

# loading packages
lapply(c("twitteR", "dplyr", "ggplot2", "lubridate", "network", "sna",
            "qdap", "tm"), FUN = library, character.only = TRUE)
theme_set(new = theme_bw())
source("local_functions.R")

# Authentication
source("nesrea_twitterAuth.R")
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
rm(access_secret, access_token, consumer_key, consumer_secret)
rand <- sample(1:2000, 1)
set.seed(rand) # Change per session
rm(rand)

# harvest data
tweets <- searchTwitter("NESREA", n = 100, since = "2016-07-29", until = "2016-08-07")

# save data
saveRDS(tweets, "NESREA_tweets.rds")

# put into dataframe
df <- twListToDF(tweets)
rm(tweets)
df$text <- stringr::str_replace_all(df$text, "[^[:graph:]]", " ")
dim(df)

# Timing of tweets
df$created <- with_tz(df$created, "Africa/Lagos")

timeDist <- ggplot(df, aes(created)) +
  geom_density(aes(fill = isRetweet), alpha = .5) +
  theme(legend.justification = c(1, 1), legend.position = c(1, 1)) +
  xlab("All tweets")
timeDist

# Zoom in on a particular day
dayOf <- filter(df, mday(created) == 1)
timeDistDayOf <- ggplot(dayOf, aes(created)) +
  geom_density(aes(fill = isRetweet), adjust = 2.5, alpha = .5) +
  theme(legend.justification = c(1, 1), legend.position = c(1, 1)) +
  xlab("Tweets of 30 July 2016")
timeDistDayOf
cowplot::plot_grid(timeDist, timeDistDayOf) # ALL + FOCUSED tweets side-by-side


# What platforms are being used?
oldpar <- par()
par(mar = c(3, 3, 3, 2))
df$statusSource <- substr(df$statusSource,
                          regexpr('>', df$statusSource) + 1,
                          regexpr('</a>', df$statusSource) - 1)
dotchart(sort(table(df$statusSource)))
mtext('Number of tweets posted by platform')
par(oldpar)

# Split into retweets and original tweets
spl <- split(df, df$isRetweet)
orig <- spl[['FALSE']]

# Extract the retweets and pull the original author's screenname
RT <- mutate(spl[['TRUE']], sender = substr(text, 5, regexpr(':', text) - 1))

pol <- lapply(orig$text, function(txt) {
  gsub("(\\.|!|\\?)+\\s+|(\\++)", " ", txt) %>%    # strip sentence enders and +'s
    gsub(" http[^[:blank:]]+", "", .) %>%          # strip URLs
    polarity(.)                                    # calculate polarity
})

orig$emotionalValence <- sapply(pol, function(x) x$all$polarity)

# What are the most and least positive tweets?
orig$text[which.max(orig$emotionalValence)]
orig$text[which.min(orig$emotionalValence)]

# How does emotionalValence change over the day?
filter(orig, mday(created) == 30) %>%
  ggplot(aes(created, emotionalValence)) +
  geom_point() +
  geom_smooth(span = .5)

# Do happier tweets get retweeted the more?
ggplot(orig, aes(emotionalValence, retweetCount)) +
  geom_point(position = 'jitter') +
  geom_smooth()

# Examine emotional content
polWordTable <- sapply(pol, function(p) {
  words = c(positiveWords = paste(p[[1]]$pos.words[[1]], collapse = ' '),
            negativeWords = paste(p[[1]]$neg.words[[1]], collapse = ' '))
  gsub('-', '', words) # Get rid of nothing found's "-"
}) %>%
  apply(1, paste, collapse = ' ') %>%
  stripWhitespace() %>%
  strsplit(' ') %>%
  sapply(table)

par(mfrow = c(1, 2))
invisible(
  lapply(1:2, function(i) {
    dotchart(sort(polWordTable[[i]]), cex = .8)
    mtext(names(polWordTable)[i])
  }))


# Emotionally associated non-negative words (Wordclouds)
polSplit <- split(orig, sign(orig$emotionalValence))
polText <- sapply(polSplit, function(df) {
  paste(tolower(df$text), collapse = ' ') %>%
    gsub(' http|@)[^[:blank:]]+', '', .) %>%    # No URLs & handles
    gsub('[[:punct:]]', '', .)                  # No punctuations
}) %>%
  structure(names = c('negative', 'neutral', 'positive'))

# remove emotive words
polText['negative'] <- removeWords(polText['negative'],
                                   names(polWordTable$negativeWords))
polText['positive'] <- removeWords(polText['positive'],
                                   names(polWordTable$positiveWords))
par(oldpar)           # return to default graphical parameters

# Make a corpus by valence and a wordcloud from it
corp <- make_corpus(polText)
col3 <- RColorBrewer::brewer.pal(3, 'Paired') # Define colours
wordcloud::comparison.cloud(as.matrix(TermDocumentMatrix(corp)),
                            max.words = 150, min.freq = 1, 
                            random.order = FALSE, rot.per = 0,
                            colors = col3, vfont = c("sans serif", "plain"))


# Who's retweeting who?
# Adjust retweets to create an edgelist for network
edglst <- as.data.frame(cbind(sender = tolower(RT$sender),
                              receiver = tolower(RT$screenName)))
edglst <- count(edglst, sender, receiver)
rtnet <- network(edglst, matrix.type = 'edgelist', directed = TRUE,
                 ignore.eval = FALSE, names.eval = 'num')

# Get names of only those who were retweeted to keep labeling reasonable
vlabs <- rtnet %v% 'vertex.names'
vlabs[degree(rtnet, cmode = 'outdegree') == 0] <- NA

par(mar = c(0, 0, 3, 0))
plot(rtnet, label = vlabs, label.pos = 5, label.cex = .8,
     vertex.cex = log(degree(rtnet)) + .5, vertex.col = col3[1],
     edge.lwd = 'num', edge.col = 'gray70',
     main = 'NESREA Retweet Network')

# Extract who is mentioned in each tweet
mentioned <- lapply(orig$text, function(tx) {
  matches <- gregexpr('@[^([:blank:]|[:punct:])]+', tx)[[1]]
  sapply(seq_along(matches), function(i)
    substr(tx, matches[i] + 1, matches[i] + attr(matches, 'match.length')[i] - 1))
})

# ----------------- REVIEW THESE LINES OF CODE LATER ---------------- #

# Make an edge from the tweeter to the mentioned, for each mention
mentionEL <- lapply(orig$text, function(i) {
  # If the tweet didn't have a mention, don't make edges
  if(mentioned[[i]] == '')
    return(NULL)
  # Otherwise, loop over each person mentioned, make an edge, and rbind them
  lapply(mentioned[[i]], function(m)
    c(sender = orig$screenName[i], receiver = m)) %>%
    do.call(rbind, .) %>% as.data.frame()
}) %>%
  do.call(rbind, .) %>%
  count(tolower(sender), tolower(receiver))

# Make the network
mentionNet <- network(mentionEL, matrix.type = 'edgelist', directed = TRUE,
                      ignore.eval = FALSE, names.eval = 'num')

# Color speakers and the host
vCol <- rep(col3[3], network.size(mentionNet))
speakers <- c("BroVic", "estherclimate", "amakaly")
vCol[(mentionNet %v% 'vertex.names') %in% speakers] <- col3[1]
vCol[mentionNet %v% 'vertex.names' == 'NESREANigeria']

plot(mentionNet, displaylabels = TRUE, label.pos = 5, label.cex = .8,
     vertex.cex = degree(mentionNet, cmode = 'indegree'), vertex.col = vCol,
     edge.lwd = 'num', legend = c('Speaker', 'Host', 'Other'),
     pt.bg = col3, pch = 21, pt.cex = 1.5, bty = 'n')

