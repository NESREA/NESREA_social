# shinyNESREA_Server.R
# A Shiny App for Exploratory Data Analysis of the NESREA Twitter handle

lapply(c("shiny", "twitteR", "dplyr", "ggplot2", "lubridate", "network", "sna",
            "qdap", "tm"), FUN = library, character.only = TRUE)
theme_set(new = theme_bw())
source("helpers.R")

shinyServer(function(input, output) {
  
  dataInput <- reactive({
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
      oldpar <- par()
      par(mar = c(3, 3, 3, 2))
      temp_data <- dataInput()
      temp_data$statusSource <- substr(temp_data$statusSource,
                                regexpr('>', temp_data$statusSource) + 1,
                                regexpr('</a>', temp_data$statusSource) - 1)
      dotchart(sort(table(temp_data$statusSource)))
      mtext('Number of tweets posted by platform')
      par(oldpar)
    }
    else if (input$outputstyle == "Wordcloud") {
      # some code...
    }
    else if (input$outputstyle == "Graph") {
      # some code...
    }
  })
  
})