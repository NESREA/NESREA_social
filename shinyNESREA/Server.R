# shinyNESREA_Server.R
# A Shiny App for Exploratory Data Analysis of the NESREA Twitter handle

lapply(c("shiny", "twitteR", "dplyr", "ggplot2", "lubridate", "network", "sna",
            "qdap", "wordcloud", "tm", "stringr"),
       FUN = library, character.only = TRUE)
theme_set(new = theme_bw())
source("helpers.R")

shinyServer(function(input, output) {
  dataInput <- reactive({
    if (input$oauth)
      source("authentication.R")
    input$goButton
    tweets <- isolate(
      searchTwitter(as.character(input$searchTerm), n = 100, # create no. input
                            since = as.character(input$startDate),
                            until = as.character(input$endDate))
    )
    df <- twListToDF(tweets)
    df$text <- str_replace_all(df$text, "[^[:graph:]]", " ")
    df
  })
  
  output$twtDensity <- renderPlot({
	temp_data <- dataInput()
	spl <- split(temp_data, temp_data$isRetweet)
	orig <- spl[['FALSE']]
	pol <- lapply(orig$text, function(txt) {
        gsub("(\\.|!|\\?)+\\s+|(\\++)", " ", txt) %>%
        gsub(" http[^[:blank:]]+", "", .) %>%
        polarity(.)
      })

  if (input$outputstyle == "Density plot") {
      tweetDistr <- ggplot(temp_data, aes(created)) +
        geom_density(aes(fill = isRetweet), alpha = .5) +
        theme(legend.justification = c(1, 1), legend.position = c(1, 1)) +
        xlab("All tweets")
      tweetDistr
    }
	else if (input$outputstyle == "Platforms") {
      temp_data$statusSource <- substr(temp_data$statusSource,
                                regexpr('>', temp_data$statusSource) + 1,
                                regexpr('</a>', temp_data$statusSource) - 1)
      dotchart(sort(table(temp_data$statusSource)))
      mtext('Number of tweets posted by platform')
	}
	else if (input$outputstyle == "Emotions plot") {
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
	}
	else if (input$outputstyle == "Wordcloud") {
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
      col3 <- color()
      comparison.cloud(as.matrix(TermDocumentMatrix(corp)),
                                  max.words = 150, min.freq = 1, 
                                  random.order = FALSE, rot.per = 0,
                                  colors = col3, vfont = c("sans serif", "plain"))
    }
	else if (input$outputstyle == "Network") {
      col3 <- color()
      
      RT <- mutate(spl[['TRUE']],
                   sender = substr(text, 5, regexpr(':', text) - 1))
      edglst <- as.data.frame(cbind(sender = tolower(RT$sender),
                              receiver = tolower(RT$screenName)))
      
      edglst <- count(edglst, sender, receiver)
      rtnet <- network(edglst, matrix.type = 'edgelist', directed = TRUE,
                 ignore.eval = FALSE, names.eval = 'num')
      
      vlabs <- rtnet %v% "vertex.names"
      vlabs[degree(rtnet, cmode = 'outdegree') == 0] <- NA
      
      plot(rtnet, label = vlabs, label.pos = 5, label.cex = .8,
           vertex.cex = log(degree(rtnet)) + .5, vertex.col = col3[1],
           edge.lwd = 'num', edge.col = 'gray70',
           main = paste(input$searchTerm, "Retweet Network"))

    }
  })
  
})