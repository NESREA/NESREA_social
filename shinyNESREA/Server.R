# shinyNESREA_Server.R
# A Shiny App for Exploratory Data Analysis of the NESREA Twitter handle

library(shiny)
library(ggplot2); theme_set(new = theme_bw())

df <- readRDS("~/7-NESREA/SA/WMG/socialmedia/shinyNESREA/data/nesrea-tweet-df.rds")

shinyServer(function(input, output) {
  
  output$twtDensity <- renderPlot({
    tweetDistr <- ggplot(df, aes(created)) +
      geom_density(aes(fill = isRetweet), alpha = .5) +
      theme(legend.justification = c(1, 1), legend.position = c(1, 1)) +
      xlab("All tweets")
    tweetDistr
  })
  
})