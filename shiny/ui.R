library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  titlePanel("Nightlife-related Noise Complaints in NYC"),
    sidebarPanel(
      checkboxGroupInput("borough",
                         "Select Borough:",
                         choices=c("Manhattan", "Brooklyn", "Bronx", "Queens", "Staten Island", "All")),
      sliderInput("monthRange", "Month:",
                   min = 1, max = 12, value = 1
       ),
      sliderInput("dayRange", "Date:",
                   min = 1, max = 31, value = 1
       )
    ),
    mainPanel(
      h3('MAIN PANEL'),
      tableOutput("nycTable")
    )
  )
)
