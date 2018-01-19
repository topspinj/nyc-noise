library(shiny)
library(readr)
library(leaflet)
library(dplyr)
library(ggplot2)
library(plotly)
library(forcats)
nycNoise <- read_csv('../data/data_wrangled.csv')
noiseByMonth <- read_csv('../data/data_by_month.csv')

shinyServer(function(input, output) {
  # summary mode
  
  nycNoise2016 <- reactive({
    nycNoise %>% 
      filter(year_created == 2016 | year_created == 2017)
  })
  output$dayOfWeek <- renderPlotly({
    yaxis = list(
      title = 'count'
    )
    xaxis = list(
      title = 'day of week'
    )    
    nycNoise2016() %>% count(weekday, borough) %>%
    plot_ly(x = ~weekday, y = ~n, color=~borough, type="bar") %>% 
      layout(xaxis = xaxis, yaxis = yaxis)
  })
  
  output$byTime <- renderPlotly({
    yaxis = list(
      title = 'count'
    )
    xaxis = list(
      title = 'time of day'
    )
    
    nycNoise2016() %>% count(hour_created) %>% 
      plot_ly(x=~hour_created, y=~n, type="scatter", mode="lines") %>% 
      layout(xaxis = xaxis, yaxis = yaxis)
  })

  
  output$byMonth <- renderPlotly({
    yaxis = list(
      title = 'count'
    )
    xaxis = list(
      title = 'month'
    )
      plot_ly(noiseByMonth, x = ~month_created ~ fct_reorder(month, month_created), y = ~count, color=~borough, type="scatter", mode="lines")
  })
  
  output$byBorough <- renderPlotly({
    nycNoise2016() %>% count(borough) %>% 
      plot_ly(x=~borough, y=~n, type="bar")
  })
  
  # analysis mode
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
      plot_ly(x = ~hour_created, y = ~n, type="bar", color = 'dark red', mode='markers', text = ~paste('Time of day: ', hour_created, 'Count:', n)) %>% 
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
