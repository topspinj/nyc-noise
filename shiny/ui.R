library(shiny)
library(leaflet)
library(plotly)
library(shinycssloaders)
library(shinythemes)

shinyUI(fluidPage(
  includeCSS("styles.css"),
  titlePanel("Nightlife-related Noise Complaints in NYC"),
    tabsetPanel(
      tabPanel("Analysis",
               sidebarPanel(
                 checkboxGroupInput("borough",
                                    "Select Borough:",
                                    choices=c("Manhattan", "Brooklyn", "Bronx", "Queens", "Staten Island"),
                                    selected=c("Manhattan", "Brooklyn", "Bronx", "Queens", "Staten Island")),
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
                 h3(textOutput("selected")),
                 plotlyOutput("timePlot"),
                 h3('Where are the noise complaints happening?'),
                 leafletOutput("map"))),
      tabPanel("Summary",
          mainPanel(
               h3("Summary of Noise Complaints in NYC from January 2016 to December 2017"),
               withSpinner(plotlyOutput("dayOfWeek")),
               withSpinner(plotlyOutput("byMonth")),
               withSpinner(plotlyOutput("byBorough")),
               withSpinner(plotlyOutput("byTime"))
          )),
      selected="Analysis"
    )
)
)

