library(shiny)
library(leaflet)
library(plotly)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("simplex"),
  includeCSS("styles.css"),
  titlePanel("Nightlife-related Noise Complaints in NYC"),
    tabsetPanel(
      tabPanel("Summary",
               sidebarPanel(
                 checkboxGroupInput("c",
                                    "Select plots:",
                                    choices=c("by borough", "by month", "by day of week", "by time of day"))
               ),
          mainPanel(
               h3("Summary of Noise Complaints in NYC from January 2016 to December 2017"),
               plotlyOutput("dayOfWeek"),
               plotlyOutput("byMonth"),
               plotlyOutput("byBorough"),
               plotlyOutput("byTime"))
          ),
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
                 plotlyOutput("timePlot"),
                 verbatimTextOutput("event"),
                 leafletOutput("map"))),
      selected="Analysis"
    )
)
)
