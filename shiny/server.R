library(dplyr)
library(ggplot2)
library(forcats)
library(lubridate)

shinyServer(function(input, output) {
  # summary mode
  nycNoise2016 <- reactive({
    df<-nycNoise %>% 
      filter(year_created == 2016 | year_created == 2017) %>%
      filter(borough == input$borough) %>% 
      group_by(year_created, month_created, day_created, hour_created) %>% 
      summarise(
        count = n()
      ) %>% 
      group_by(hour_created) %>% 
      summarise(
        mean = mean(count),
        max = max(count),
        min = min(count)
      )
    df$hour_created <- substr(as.POSIXct(sprintf("%04.0f", df$hour_created*100), format='%H%M'), 12, 16)
    df
  })
  
  nycData <- reactive({
      df <- nycNoise %>% 
        filter(month_created == month(input$date),
               day_created == day(input$date),
               year_created == year(input$date),
               borough == input$borough)
      
      df$hour_created <- substr(as.POSIXct(sprintf("%04.0f", df$hour_created*100), format='%H%M'), 12, 16)
      df
  })
  
  noiseMonth <- reactive({
    noiseByMonth %>% 
      filter(borough == input$borough)
  })
  
  
  
  output$byMonth <- renderPlotly({
    xaxis = list(
      title = 'month',
      tickangle=-90,
      titlefont = list(size = 12),
      tickfont=list(size=9)
      )
    
    yaxis = list(
      title = 'count',
      titlefont = list(size = 12),
      tickfont=list(size=9) 
    )
    
    
    plot_ly(noiseByMonth, 
            x = ~month ~ fct_reorder(month, month_created), 
            y = ~count, 
            color=~borough, 
            type="scatter",
            mode="lines", line=list(width=2)) %>% 
    layout(title="<b>Complaint Counts by Month</b>",titlefont=list(size=12), xaxis=xaxis, yaxis=yaxis, legend=list(orientation = 'h', x = 0.1, y = -0.3))
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
      title = "time of day"
    )
    
    yaxis <- list(
      title = 'complaint count'
    )
    
      plot_ly(nycDataHourCount(), x = ~hour_created, y = ~n, type="bar", name=paste(format(input$date, "%b %d, %Y"))) %>% 
        add_trace(x = nycNoise2016()$hour_created, y = nycNoise2016()$mean, type = 'scatter', mode = 'lines',
                line = list(color = '#45171D'), name="average") %>% 
        layout(xaxis = xaxis, yaxis = yaxis, legend = list(orientation = 'h', x = 0.1, y = -0.3))
  })
  
  
  output$map <- renderLeaflet({
    pal <- colorFactor(c("#E38DC3", "#FE876A", "#A4D55E", "#8BA2CB", "#6EBFA6"), 
                       domain = c("Queens", "Brooklyn", "Staten Island", "Manhattan", "Bronx"))
    
    leaflet(data = nycData()) %>% 
      setView(lng = -73.95, lat = 40.78, zoom = 12) %>%
      addProviderTiles("OpenMapSurfer.Grayscale", options = providerTileOptions(minZoom = 9)) %>% 
      addCircleMarkers(~long, ~lat, color=~pal(borough), label=~as.character(borough), stroke=FALSE, fillOpacity=0.8) %>%  
      addLegend("bottomright", pal = pal, values = ~borough, title = "Boroughs",opacity = 1)
  })


  byWeekday <- reactive({
    df <- nycNoise %>% 
      group_by(weekday, borough) %>% 
      summarise(
        count = n()
      )
    df$weekday <- factor(df$weekday, c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
    df$weekday <- df$weekday %>%
      fct_recode("Mon"="Monday", "Tues"="Tuesday", "Wed"="Wednesday","Thur"= "Thursday","Fri"= "Friday", "Sat"="Saturday", "Sun"="Sunday")
    df
  })
  
  output$dayOfWeek <- renderPlotly({
    xaxis = list(
      title = 'day of week',
      titlefont = list(size = 12),
      tickfont=list(size=9),
      tickangle=-90
    ) 
    yaxis = list(
      title = 'complaint count',
      titlefont = list(size = 12),
      tickfont=list(size=9) 
    )

    plot_ly(byWeekday(), x = ~weekday, y = ~count, color=~borough, type="bar",
            text=~paste( borough, '</br>', 
                         '</br> Count:', count),
            hoverinfo="text") %>% 
      layout(title="<b>Complaint Counts by Day of Week</b>",titlefont=list(size=12), xaxis = xaxis, yaxis=yaxis, legend = list(orientation = 'h', x = 0.1, y = -0.3))
  })
  
})
