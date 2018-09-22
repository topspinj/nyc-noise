library(dplyr)
library(ggplot2)
library(forcats)
library(lubridate)

shinyServer(function(input, output) {
  nycData <- reactive({
      df <- nycNoise %>% 
        filter(month_created %in% month(input$date),
               day_created %in% day(input$date),
               year_created %in% year(input$date),
               borough %in% input$borough)
      
     df$hour_created_formatted <- substr(as.POSIXct(sprintf("%04.0f", df$hour_created*100), format='%H%M'), 12, 16)
      df
  })

  
  nycDataHourCount <- reactive({
    count(nycData(), hour_created)
  })
  
  output$selected <- renderText({
    paste(format(input$date, "%A, %B %d, %Y"))
  })
    
  output$timePlot <- renderPlotly({
    xaxis <- list(
      autotick = FALSE,
      ticks = "outside",
      tick0 = 0,
      dtick = 1,
      tickcolor = toRGB("#262626"),
      title = "time of day",
      color="white"
    )
    
    yaxis <- list(
      title = 'complaint count',
      color="white"
    )
    
      plot_ly(nycDataHourCount(), x = ~hour_created, y = ~n, type="bar", name=paste(format(input$date, "%b %d, %Y"))) %>% 
        layout(paper_bgcolor='transparent') %>% 
        layout(xaxis = xaxis, yaxis = yaxis, legend = list(orientation = 'h', x = 0.1, y = -0.3))
  })
  
  
  output$map <- renderLeaflet({
    pal <- colorFactor(
      palette = 'viridis',
      domain = nycData()$hour_created
    )
    
    leaflet(data = nycData()) %>% 
      setView(lng = -73.95, lat = 40.78, zoom = 12) %>%
      addProviderTiles("CartoDB.DarkMatter", options = providerTileOptions(minZoom = 9)) %>% 
      addCircleMarkers(~long, ~lat, color=~pal(hour_created), radius=3, label=~as.character(hour_created_formatted), stroke=FALSE, fillOpacity=0.8) %>%  
      addLegend("bottomright", pal = pal, values = ~hour_created, title = "Boroughs",opacity = 1)
  })
  
})
