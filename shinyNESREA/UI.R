# shinyNESREA_UI.R
# A Shiny App for Exploratory Data Analysis of the NESREA Twitter handle
library(shiny)

ui <- function(request){

  fluidPage(

  theme = shinythemes::shinytheme("superhero"),
  
  titlePanel(
    title = "NESREA Twitter Exploratory Dataviz",
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
      
      
      actionButton("goButton", label = "Go!"),
      
      hr(),
      
      tags$div(title = "Choose the type of output you want to view",
               selectInput("outputstyle",
                           label = "Select output type",
                           choices = c("Density plot (week)", 
                                       "Density plot (day)",
                                       "Platforms",
                                       "Emotions plot",
                                       "Wordcloud",
                                       "Network"))),
      
      hr(),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Density plot (week)'",
        dateInput("startDate", label = "From: ", value = Sys.Date() - 7,
                min = "2016-06-14", max = Sys.Date()),
        dateInput("endDate", "To: ", value = Sys.Date(), min = "2016-06-14",
                max = Sys.Date()),
        hr()
        ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Density plot (day)'",
        dateInput("checkDate", label = "Date: ", value = Sys.Date() - 1,
                  min = Sys.Date() - 7, max = Sys.Date()),
        hr()
      ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Platforms'"
        ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Emotions plot'",
        checkboxInput("emotiveExtremes",
                      label = "View emotive extremes",
                      value = FALSE),
        hr()
      ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Wordcloud'"
        ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Network'"
        ),
      
      em(a(href = "mailto:victor.ordu@nesrea.gov.ng", "Feedback/Complaints"))
    ),
    
    mainPanel(
      tags$div(title = "Plots will be displayed here.",
               plotOutput("twtDensity")),
      
      tableOutput("mostEmotive"),
      
      bookmarkButton(),
      
      width = 9
      )
    )
  )
  
}