library(shinycssloaders)
library(shinythemes)

shinyUI(fluidPage(
  theme = shinytheme("cyborg"),
  includeCSS("styles.css"),
  leafletOutput("map", height="800px"),
  
  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                draggable = TRUE, top = 20, left = 20, right = "auto", bottom = "auto",
                width = 360, height = "auto",
                h4("Noise Complaints in NYC"),
                checkboxGroupInput("borough",
                                   "Select Borough:",
                                   choices=c("Manhattan", "Brooklyn", "Bronx", "Queens", "Staten Island"),
                                   selected=c("Manhattan", "Brooklyn", "Bronx", "Queens", "Staten Island")),
                dateInput("date", label = h5("Date input"), value = "2017-09-01", min="2017-08-01", max="2018-09-01"),
                h5(textOutput("selected")),
                withSpinner(plotlyOutput("timePlot", height=250)),
                sliderInput("time", "Time of day:",
                            min = 0, max = 23,
                            value = c(0,23))
  )
  )
)

