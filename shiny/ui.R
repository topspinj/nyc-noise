library(shinycssloaders)
library(shinythemes)

shinyUI(fluidPage(
  theme = shinytheme("cyborg"),
  includeCSS("styles.css"),
  titlePanel( "Noise Complaints in NYC"),
  sidebarPanel(
    checkboxGroupInput("borough",
                       "Select Borough:",
                       choices=c("Manhattan", "Brooklyn", "Bronx", "Queens", "Staten Island"),
                       selected=c("Manhattan", "Brooklyn", "Bronx", "Queens", "Staten Island")),
    dateInput("date", label = h5("Date input"), value = "2016-01-01", min="2016-01-01", max="2018-01-15")
  ),
  mainPanel(
    h4(textOutput("selected")),
    withSpinner(leafletOutput("map")),
    withSpinner(plotlyOutput("timePlot")),
    sliderInput("time", "Time of day:",
                min = 0, max = 23,
                value = c(0,23))
   )
                 
  )
)

