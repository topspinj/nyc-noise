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
                 dateInput("date", label = h3("Date input"), value = "2016-01-01", min="2016-01-01", max="2018-01-15")
               ),
               mainPanel(
                 h4('Where are the noise complaints happening?'),
                 withSpinner(leafletOutput("map")),
                 h3(textOutput("selected")),
                 withSpinner(plotlyOutput("timePlot"))
   )
                 
  )
)

