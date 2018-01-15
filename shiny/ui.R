library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Nightlife-related Noise Complaints in NYC"),
    sidebarPanel(
       checkboxGroupInput("boroughs",
                   "Select Borough:",
                   choices=c("Manhattan", "Brooklyn", "Bronx", "Queens", "Staten Island")),
       sliderInput("month", "Month:",
                   min = 1, max = 12, value = 1
       )
    ),
    mainPanel(
      h3('MAIN PANEL'),
      tableOutput("nycTable")
    )
  )
)
