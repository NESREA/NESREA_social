# shinyNESREA_UI.R
# A Shiny App for Exploratory Data Analysis of the NESREA Twitter handle
library(shiny)

shinyUI(fluidPage(

  titlePanel(
    title = "NESREA Twitter Exploratory Data Analysis",
    windowTitle = "Twitter Shiny app - NESREA"
  ),
  
  sidebarLayout(
    sidebarPanel(
      
      width = 3,
      
      actionLink(inputId = "oauth",
                 label = "Set up a fresh Twitter OAuth session"),
      
      hr(),
      
      textInput("searchTerm", label = "Search", value = "",
                placeholder = "Term or hashtag"),
      
      actionButton("goButton", label = "Go!"),
      
      hr(),
      
      selectInput("outputstyle", label = "Select output of choice",
                  choices = c("Density plot", "Platforms",
                              "Sentiment", "Network")),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Density plot'",
        dateInput("startDate", label = "From: ", value = Sys.Date() - 7,
                min = "2016-06-14", max = Sys.Date()),
        dateInput("endDate", "To: ", value = Sys.Date(), min = "2016-06-14",
                max = Sys.Date())
        ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Platforms'"
        ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Sentiment'"
        ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Network'"
        )
    ),
    
    mainPanel(
      plotOutput("twtDensity"),
      
      width = 9
    )
    
  )
  
))
