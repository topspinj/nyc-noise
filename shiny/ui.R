library(shiny)
library(leaflet)
library(plotly)

shinyUI(fluidPage(
  titlePanel("Nightlife-related Noise Complaints in NYC"),
  sidebarPanel(
    checkboxGroupInput("borough",
                       "Select Borough:",
                       choices=c("Manhattan", "Brooklyn", "Bronx", "Queens", "Staten Island")),
    sliderInput("month", "Month:",
                min = 1, max = 12, value = 1
    ),
    sliderInput("day", "Date:",
                min = 1, max = 31, value = 1
    ),
    sliderInput("year", "Year:",
                min = 2016, 
                max = 2018, 
                value = 2016, 
                sep = ""
    )
  ),
  mainPanel(
    h3('MAIN PANEL'),
    plotlyOutput("timePlot"),
    verbatimTextOutput("info"),
    verbatimTextOutput("event"),
    leafletOutput("map")
  )
)
)