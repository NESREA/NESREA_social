# shinyNESREA_Server.R
# A Shiny App for Exploratory Data Analysis of the NESREA Twitter handle

lapply(c("shiny", "twitteR", "dplyr", "ggplot2", "lubridate", "network", "sna",
            "qdap", "tm", "wordcloud", "RColorBrewer"),
       FUN = library, character.only = TRUE)
theme_set(new = theme_bw())
source("helpers.R")

shinyServer(function(input, output) {
  dataInput <- reactive({
    if (input$oauth)
      source("authentication.R")
    input$goButton
    tweets <- isolate(
      searchTwitter(as.character(input$searchTerm), n = 100,
                            since = as.character(input$startDate),
                            until = as.character(input$endDate))
    )
    df <- twListToDF(tweets)
  })
  
  output$twtDensity <- renderPlot({
    if (input$outputstyle == "Density plot") {
      tweetDistr <- ggplot(dataInput(), aes(created)) +
        geom_density(aes(fill = isRetweet), alpha = .5) +
        theme(legend.justification = c(1, 1), legend.position = c(1, 1)) +
        xlab("All tweets")
      tweetDistr
    }
    else if (input$outputstyle == "Platforms") {
      temp_data <- dataInput()
      temp_data$statusSource <- substr(temp_data$statusSource,
                                regexpr('>', temp_data$statusSource) + 1,
                                regexpr('</a>', temp_data$statusSource) - 1)
      dotchart(sort(table(temp_data$statusSource)))
      mtext('Number of tweets posted by platform')
    }
    else if (input$outputstyle == "Sentiment") {
      temp_data <- dataInput()
      spl <- split(temp_data, temp_data$isRetweet)
      orig <- spl[['FALSE']]
      pol <- lapply(orig$text, function(txt) {
        gsub("(\\.|!|\\?)+\\s+|(\\++)", " ", txt) %>%
          gsub(" http[^[:blank:]]+", "", .) %>%
          polarity(.)
      })
      
      polWordTable <- sapply(pol, function(p) {
        words <- c(positiveWords = paste(p[[1]]$pos.words[[1]], collapse = ' '),
                   negativeWords = paste(p[[1]]$neg.words[[1]], collapse = ' '))
        gsub('-', '', words) # Get rid of nothing found's "-"
      }) %>%
        apply(1, paste, collapse = ' ') %>%
        stripWhitespace() %>%
        strsplit(' ') %>%
        sapply(table)
      
      orig$emotionalValence <- sapply(pol, function(x) x$all$polarity)
      polSplit <- split(orig, sign(orig$emotionalValence))
      polText <- sapply(polSplit, function(subdata) {
        paste(tolower(subdata$text), collapse = ' ') %>%
          gsub(' http|@)[^[:blank:]]+', '', .) %>%
          gsub('[[:punct:]]', '', .)
      }) %>%
        structure(names = c('negative', 'neutral', 'positive'))
      polText['negative'] <- removeWords(polText['negative'],
                                         names(polWordTable$negativeWords))
      polText['positive'] <- removeWords(polText['positive'],
                                         names(polWordTable$positiveWords))
      corp <- make_corpus(polText)
      col3 <- brewer.pal(3, 'Paired')
      comparison.cloud(as.matrix(TermDocumentMatrix(corp)),
                                  max.words = 150, min.freq = 1, 
                                  random.order = FALSE, rot.per = 0,
                                  colors = col3, vfont = c("sans serif", "plain"))
    }
    else if (input$outputstyle == "Graph") {
      # some code...
    }
  })
  
})