# shinyNESREA_UI.R
# A Shiny App for Exploratory Data Analysis of the NESREA Twitter handle


library(shiny)
tweets <- readRDS("data/nesrea-tweet-df.rds")

shinyUI(fluidPage(
  titlePanel(
    helpText("NESREA Twitter Exploratory Data Analysis")
  ),
  
  sidebarLayout(
    sidebarPanel(
      dateRangeInput("dates", label = "Date range", start = Sys.Date()-7,
                     end = NULL, min = "2016-06-14", max = Sys.Date())
    ),
    
    mainPanel(
      plotOutput("twtDensity")
    )
  )
)
  
)
