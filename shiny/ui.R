library(shinycssloaders)
library(shinythemes)

shinyUI(fluidPage(
  includeCSS("styles.css"),
  titlePanel("Nightlife-related Noise Complaints in NYC"),

               sidebarPanel(
                 checkboxGroupInput("borough",
                                    "Select Borough:",
                                    choices=c("Manhattan", "Brooklyn", "Bronx", "Queens", "Staten Island"),
                                    selected=c("Manhattan", "Brooklyn", "Bronx", "Queens", "Staten Island")),
                 dateInput("date", label = h3("Date input"), value = "2016-01-01", min="2016-01-01", max="2018-01-15")
               ),
               mainPanel(
                 h3(textOutput("selected")),
                 plotlyOutput("timePlot"),
                 h3('Where are the noise complaints happening?'),
                 leafletOutput("map"),
                 fluidRow(
                   splitLayout(height=1, plotlyOutput('byMonth'), plotlyOutput('byBorough'))
                 ))
  )
)

