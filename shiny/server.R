library(shiny)
library(readr)
library(leaflet)

nycNoise <- read_csv('../data/data_wrangled.csv')

shinyServer(function(input, output) {
  
  nycData  <- reactive({
    nycNoise %>% 
      filter(month_created == input$month,
             day_created == input$day,
             year_created == input$year)
  })
  
  output$nycTable <- renderTable({ 
    nycData()
  })
  
  output$timePlot <- renderPlot({
    if(is.null(nycData())) {
      return(NULL)
    }
    ggplot(nycData(), aes(hour_created)) + 
      geom_histogram(fill="red") +
      xlab("hour") +
      ylab("frequency") +
      theme_minimal()
  })
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    pal <- colorFactor(c("navy", "red", "dark green", "black", "yellow", "orange"), 
                       domain = c("Queens", "Brooklyn", "Staten Island", "Manhattan", "Bronx", "Long Island"))
    leaflet(data = nycData()) %>% addTiles() %>%
      addCircleMarkers(~long, ~lat, label = ~as.character(borough), color = ~pal(borough), fillOpacity = 0.5)
  })
})

