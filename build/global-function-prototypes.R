## global-function-prototypes.R

## Calclates the polarity for each text field
compute_emotional_valence <- function(text.var) {
  suppressWarnings(
    lapply(text.var, function(txt) {
      gsub("(\\.|!|\\?)+\\s+|(\\++)", " ", txt) %>%
        gsub(" http[^[:blank:]]+", "", .) %>%
        qdap::polarity(.)
    })
  )
}

## Makes a table of words from both sides of the aisle :P
make_word_table <- function(pol.list) {
  sapply(pol.list, function(p) {
    words <- 
      c(positiveWords = paste(p$all$pos.words[[1]], collapse = ' '),
        negativeWords = paste(p$all$neg.words[[1]], collapse = ' '))
    gsub('-', '', words)
  }) %>%
    apply(MARGIN = 1, FUN = paste, collapse = ' ') %>%
    stripWhitespace() %>%
    strsplit(' ') %>%
    sapply(table, simplify = FALSE)
}

## Displays the occurence of words on either side of the
## spectrum using a dot plot
visualise_pol_diff <- function(pol.list) {
  pol.tab <- make_word_table(pol.list)
  oldpar <- par()
  par(mfrow = c(1, 2))
  invisible(
    lapply(1:2, function(i) {
      suppressWarnings(dotchart(sort(pol.tab[[i]]), cex = .8))
      mtext(names(pol.tab)[i])
    })
  )
  suppressWarnings(par(oldpar))
}

## Generates a tag cloud
generate_wordcloud <- function(data, pol.list, site) {
  pol.tab <- make_word_table(pol.list)
  polSplit <- split(data, sign(data$emotionalValence))
  pick <- choose_platform(site)
  var <- c("text", "message")
  var <- var[pick]
  
  if (length(polSplit) != 3) {
    cat("Insufficient data to render the wordcloud\n")
  } else {
    polText <- sapply(polSplit, function(df) {
      paste(tolower(df[, var]), collapse = ' ') %>%
        gsub(' http|@)[^[:blank:]]+', '', .) %>%
        gsub('[[:punct:]]', '', .)
    }) %>%
      structure(names = c('negative', 'neutral', 'positive'))
    
    polText['negative'] <-
      removeWords(polText['negative'], names(pol.tab$negativeWords))
    polText['positive'] <-
      removeWords(polText['positive'], names(pol.tab$positiveWords))
    
    corp <- make_corpus(polText)
    col3 <- RColorBrewer::brewer.pal(3, 'Paired')
    
    ## Adjust margins to make room for a title
    layout(mat = matrix(c(1, 2), nrow = 2), heights = c(1, 4))
    par(mar = rep(0, 4))
    plot.new()
    text(x = 0.5, y = 0.5,
         sprintf("Comparison Cloud of Words from %s Data", site))
    suppressWarnings(
      comparison.cloud(as.matrix(TermDocumentMatrix(corp)),
                       max.words = 150,
                       min.freq = 1,
                       random.order = FALSE,
                       rot.per = 0,
                       colors = col3,
                       vfont = c("sans serif", "plain")))
  }
}

## Makes a volatile corpus and prepare
make_corpus <- function(GText, stem = TRUE) {
  corp <- VCorpus(VectorSource(GText)) %>% 
    tm_map(removePunctuation) %>%
    tm_map(stripWhitespace) %>%
    tm_map(content_transformer(tolower)) %>%
    tm_map(removeWords, stopwords("english"))
  if(stem)
    corp <- tm_map(corp, stemDocument) 
  
  names(corp) <- names(GText)
  corp
}

## source_but_also_check_for()
## We want to not only source certain project files, but also ensure that
## such files exist. Once done, clean up is done
source_but_also_check_for <- function(ff) {
  sapply(ff, function(x) {
    if (file.exists(x)) {
      source(x)
    } else {
      warning(paste(sQuote(x), "was not found in the working directory"))
    }
  })
}

## Plots a simple density plot for the data
plain_dens_plot <- function(data, platform)
{
  choice <- choose_platform(site = platform)
  type <- c("tweets", "comments")
  var <- c("created", "created_time")
  hue <- c("red", "darkblue")
  title <- paste("Proportion of", type[choice])
  gg <- ggplot(data, aes_string(var[choice])) +
    geom_density(fill = hue[choice], alpha = 0.4) +
    theme(legend.justification = c(1, 1), legend.position = c(1, 1)) +
    ggtitle(title) +
    xlab("Date")
  gg
}

## Selects the appropriate social media platform being analysed
choose_platform <- function(site = character()) {
  if(tolower(site) == "twitter")
    return(1)
  else if (tolower(site) == "facebook")
    return(2)
  else
    stop("Provide a supported social media platform.")
}

## Returns a message that matches  particular
## metric (used only inside the body text)
return_text <- function(df, metric) {
  column <- select(df, match(metric, colnames(df))) %>%
    unlist(.)
  txt <- df$message[match(max(column), column)]
  txt
}

## Makes sure that text-based columns contain human readable characters only
remove_nonreadables <- function(string = NULL) {
  require(stringr)
  if (is.null(string))
    warning("No text data were available for reading.")
  nu.str <- string %>%
    gsub("[^[:graph:]]", " ", .) %>%
    str_trim()
  nu.str
}