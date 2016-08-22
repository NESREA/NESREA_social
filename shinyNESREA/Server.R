# shinyNESREA_Server.R
# A Shiny App for Exploratory Data Analysis of the NESREA Twitter handle

library(shiny)
library(twitteR)
library(ggplot2); theme_set(new = theme_bw())

<<<<<<< HEAD
df <- readRDS("~/7-NESREA/SA/WMG/socialmedia/NESREA_Twitter/shinyNESREA/data/nesrea-tweet-df.rds")

=======
>>>>>>> reactive
shinyServer(function(input, output) {
  
  dataInput <- reactive({
    tweets <- searchTwitter("NESREA", n = 100,
                            since = as.character(input$startDate),
                            until = as.character(input$endDate))
    df <- twListToDF(tweets)
  })
  
  output$twtDensity <- renderPlot({
    tweetDistr <- ggplot(dataInput(), aes(created)) +
      geom_density(aes(fill = isRetweet), alpha = .5) +
      theme(legend.justification = c(1, 1), legend.position = c(1, 1)) +
      xlab("All tweets")
    tweetDistr
  })
  
})