library(shiny)
library(readr)
library(leaflet)
library(dplyr)
library(ggplot2)
library(plotly)

nycNoise <- read_csv('../data/data_wrangled.csv')

print(str(nycNoise))

shinyServer(function(input, output) {
  
  nycData <- reactive({
      df <- nycNoise %>% 
        filter(month_created == input$month,
               day_created == input$day,
               year_created == input$year,
               borough == input$borough)
  })

  output$nycTable <- renderTable({ 
    nycData()
  })
  
  
  output$timePlot <- renderPlotly({
    xaxis <- list(
      autotick = FALSE,
      ticks = "outside",
      tick0 = 0,
      dtick = 1,
      tickcolor = toRGB("#262626"),
      title = "time of day"
    )
    
    yaxis <- list(
      title = 'count'
    )
    
    nycData() %>% count(hour_created) %>%
      plot_ly(x = ~hour_created, y = ~n, type="bar", color = 'dark red') %>% 
      layout(xaxis = xaxis, yaxis = yaxis)
  
  })
  
  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover on a point!" else d
  })
  
  
  output$map <- renderLeaflet({
    pal <- colorFactor(c("#003432", "#AC1C18", "#191C59", "#2E0239", "#F7B500",  "#0B1AAA"), 
                       domain = c("Queens", "Brooklyn", "Staten Island", "Manhattan", "Bronx", "Long Island"))
    leaflet(data = nycData()) %>% addTiles() %>%
      addCircleMarkers(~long, ~lat, label = ~as.character(borough), color = ~pal(borough), radius = 4, fillOpacity = 0.5)
  })

})
