# shinyNESREA_UI.R
# A Shiny App for Exploratory Data Analysis of the NESREA Twitter handle
library(shiny)

shinyUI(fluidPage(

  theme = shinythemes::shinytheme("superhero"),
  
  titlePanel(
    title = "NESREA Twitter Exploratory Dataviz",
    windowTitle = "Twitter Shiny app - NESREA"
  ),
  
  sidebarLayout(
    sidebarPanel(
      
      width = 3,
      
      strong(actionLink(inputId = "oauth",
                 label = "Click to register new session")),
      
      hr(),
      
      textInput("searchTerm", label = "Search", value = "nesreanigeria",
                placeholder = "Term or hashtag"),
      
      actionButton("goButton", label = "Go!"),
      
      hr(),
      
      selectInput("outputstyle",
                  label = "Select output type",
                  choices = c("Density plot (week)", "Density plot (day)",
                              "Platforms", "Emotions plot", "Wordcloud",
                              "Network")),
      
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
        condition = "input.outputstyle == 'Emotions plot'"
      ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Wordcloud'"
        ),
      
      conditionalPanel(
        condition = "input.outputstyle == 'Network'"
        ),
      
      hr(),
      
      em(a(href = "mailto:victor.ordu@nesrea.gov.ng", "Feedback/Complaints"))
    ),
    
    mainPanel(
      plotOutput("twtDensity"),
      
      width = 9
    )
  )
  
))