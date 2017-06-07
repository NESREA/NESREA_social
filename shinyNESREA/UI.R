# shinyNESREA_UI.R
# A Shiny App for Exploratory Data Analysis of the NESREA Twitter handle
library(shiny)

ui <- function(request){

  fluidPage(

  theme = shinythemes::shinytheme("superhero"),
  
  titlePanel(
    title = "NESREA SMExplorer",
    windowTitle = "Twitter Shiny app - NESREA"
  ),
  
  sidebarLayout(
    sidebarPanel(
      
      width = 3,
      
      tags$div(title = "Click here to submit authentication credentials and 
               start a new session",
               strong(actionLink(inputId = "oauth",
                                 label = "Register new session"))),
      
      hr(),
      
      
      tags$div(title = "Type in what you're searching for here",
               textInput("searchTerm", label = "Search", value = "nesreanigeria",
              placeholder = "Term or hashtag")),
      
      tags$div(title = "Choose the type of output you want to view",
               selectInput("outputstyle",
                           label = "Select output type",
                           choices = c("Density plot (week)", 
                                       "Density plot (day)",
                                       "Platforms",
                                       "Emotions plot",
                                       "Wordcloud",
                                       "Network"))),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Density plot (week)'",
        dateInput("startDate", label = "From: ", value = Sys.Date() - 7,
                min = "2016-06-14", max = Sys.Date()),
        dateInput("endDate", "To: ", value = Sys.Date(), min = "2016-06-14",
                max = Sys.Date())
        ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Density plot (day)'",
        dateInput("checkDate", label = "Date: ", value = Sys.Date() - 1,
                  min = Sys.Date() - 7, max = Sys.Date())
      ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Platforms'"
        ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Emotions plot'",
        checkboxInput("emotiveExtremes",
                      label = "View emotive extremes",
                      value = FALSE)
      ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Wordcloud'"
        ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Network'"
        ),
      
      div(style = "border: 1px dotted black; background: dark-grey;
          width: 60px",
          actionButton("goButton", label = "Go!")),
      
      hr(),
      
      em(a(href = "https://github.com/NESREA/NESREA_social/issues/new",
           "Feedback/Bug Reports"))
    ),
    
    mainPanel(
      tags$div(title = "Plots will be displayed here.",
               plotOutput("twtDensity")),
      
      div(style = "display:inline-block; vertical-align:top; padding-top:20px;
          font-size: small;",
          textOutput("twtnum", inline = TRUE)),
      
      div(
        style = "display:inline-block; vertical-align:top;",
        selectInput("numLoaded",
                    label = "",
                    width = "70px",
                    choices = c(25, 50, 100, 150, 200, 250, 300, 500, 1000))),
      
      div(style = "display:inline-block; vertical-align:top;
          padding-left: 10px; padding-top: 20px; margin-left: 30px",
          bookmarkButton()),
      
      tableOutput("mostEmotive"),
      
      width = 9
      
      )
    )
  )
  
}