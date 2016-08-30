# shinyNESREA_UI.R
# A Shiny App for Exploratory Data Analysis of the NESREA Twitter handle


library(shiny)

shinyUI(fluidPage(
  titlePanel(
    helpText("NESREA Twitter Exploratory Data Analysis")
  ),
  
  sidebarLayout(
    sidebarPanel(
      
      dateInput("startDate", label = "From: ", value = Sys.Date() - 7,
                min = "2016-06-14", max = Sys.Date()),
      
      dateInput("endDate", "To: ", value = Sys.Date(), min = "2016-06-14",
                max = Sys.Date()),
      
      hr(),
      
      textInput("searchTerm", label = "Search", value = "nesrea"),
      
      width = 3
    ),
    
    mainPanel(
      plotOutput("twtDensity"),
      
      width = 9
    )
  )
)
  
)
