# shinyNESREA_Server.R
# A Shiny App for Exploratory Data Analysis of the NESREA Twitter handle
# Inspired by Michael Levy - http://michaellevy.name/blog/conference-twitter/

packages <- c("shiny", "twitteR", "dplyr", "ggplot2", "lubridate", "network",
              "sna", "qdap", "wordcloud", "tm", "stringr")
lapply(packages, FUN = library, character.only = TRUE)

theme_set(new = theme_bw())
source("helpers.R")

shinyServer(function(input, output, session) {

  dataInput <- reactive({
    if (input$oauth)
      source("authentication.R")
    input$goButton
    tweets <- isolate(
      searchTwitter(as.character(input$searchTerm),
                    n = input$numLoaded,
                    since = as.character(input$startDate),
                    until = as.character(input$endDate))
      )
    df <- twListToDF(tweets)
    df$text <- str_replace_all(df$text, "[^[:graph:]]", " ")
    df
  })
  
  
  output$twtDensity <- renderPlot({
    
    main_objects <- prepareObjects(dataInput())
    spl <- main_objects$split
    orig <- main_objects$original
    pol <- main_objects$polarity
    polWordTable <- createWordList(pol)
    
	  # options for the various plots
    if (input$outputstyle == "Density plot (week)") {
      checkWeek <- dataInput()
      dW <- plotDensity(data = checkWeek, entry = input$searchTerm, daily = FALSE)
      dW
    }
  	else if (input$outputstyle == "Density plot (day)") {
  	  checkday <- filter(dataInput(), mday(created) == day(input$checkDate))
  	  densDay <- plotDensity(checkday, entry = input$searchTerm, daily = TRUE)
  	  densDay
  	}
  	else if (input$outputstyle == "Platforms") {
  	  temp_data <- dataInput()
  	  temp_data$statusSource <- substr(temp_data$statusSource,
                                  regexpr('>', temp_data$statusSource) + 1,
                                  regexpr('</a>', temp_data$statusSource) - 1)
        dotchart(sort(table(temp_data$statusSource)))
        mtext(textOnTweetsByPlatform)
  	}
  	else if (input$outputstyle == "Emotions plot") {
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
        
        polText <- processBagofWords(polSplit, polWordTable)
        
        corp <- make_corpus(polText)
        col3 <- color()
        comparison.cloud(as.matrix(TermDocumentMatrix(corp)),
                         max.words = 150,
                         min.freq = 1,
                         random.order = FALSE,
                         rot.per = 0,
                         colors = col3,
                         vfont = c("sans serif", "plain"))
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
        plot(rtnet,
             label = vlabs,
             label.pos = 5,
             label.cex = .8,
             vertex.cex = log(degree(rtnet)) + .5,
             vertex.col = col3[1],
             edge.lwd = 'num',
             edge.col = 'gray70',
             main = paste0("Retweet Network on the term '",
                           input$searchTerm, "'"))
        }
    })
  
  output$mostEmotive <- renderTable({
    if (input$emotiveExtremes && input$outputstyle == "Emotions plot")
    {
      main_objects <- prepareObjects(dataInput())
      pol <- main_objects$polarity
      orig <- main_objects$original
      polWordTable <- createWordList(pol)
      orig$emotionalValence <- sapply(pol, function(x) x$all$polarity)
      
      # Render the table
      extremes <- data.frame(
        mostPositive = orig$text[which.max(orig$emotionalValence)],
        mostNegative = orig$text[which.min(orig$emotionalValence)]
      )
      print(extremes)
    }
  })
  
  output$twtnum <- renderText({
    
    temp <- dataInput()
    paste(nrow(temp), textOnLoadedTweets)
    
    })

})