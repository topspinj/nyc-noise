library(dplyr)
library(ggplot2)
library(forcats)

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
  
  nycNoise2016summary <- reactive({
    df<-nycNoise %>% 
      filter(year_created == 2016 | year_created == 2017)
  })
  
  byWeekday <- reactive({
    df <- nycNoise %>% 
      group_by(weekday) %>% 
      summarise(
        count = n()
      )
    df$weekday <- factor(df$weekday, c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
    df
  })
  
  output$dayOfWeek <- renderPlotly({
    yaxis = list(
      title = 'complaint count'
    )
    xaxis = list(
      title = 'day of week',
      tickfont=list(size=10)
    ) 

    plot_ly(byWeekday(), x = ~weekday, y = ~count, type="bar",
            text=~paste( weekday, '</br>', 
                        '</br> Count:', count),
            hoverinfo="text") %>% 
      layout(xaxis = xaxis, yaxis = yaxis)
  })
  
  
  output$byMonth <- renderPlotly({
    yaxis = list(
      title = 'complaint count'
    )
    xaxis = list(
      title = 'month',
      tickangle=-90
    )

      plot_ly(noiseByMonth, x = ~month ~ fct_reorder(month, month_created), y = ~count, color=~borough, type="scatter", mode="lines", line=list(width=4)) %>% 
        layout(hovermode = 'compare', yaxis=yaxis, xaxis=xaxis, margin = list(b = 70))
  })
  
  output$byBorough <- renderPlotly({
    yaxis = list(
      title = 'complaint count'
    )
    xaxis = list(
      title = 'borough'
    )
    nycNoise2016summary() %>% count(borough) %>% 
      plot_ly(x=~borough, y=~n, type="bar", 
              text = ~paste('Borough: ', 
                        borough, '</br>', 
                        '</br> Count:', n),
              hoverinfo="text") %>% 
      layout(xaxis=xaxis, yaxis=yaxis)
  })
  
  # analysis mode
  nycData <- reactive({
      df <- nycNoise %>% 
        filter(month_created == input$month,
               day_created == input$day,
               year_created == input$year,
               borough == input$borough)
      
      df$hour_created <- substr(as.POSIXct(sprintf("%04.0f", df$hour_created*100), format='%H%M'), 12, 16)
      df
  })
  
  nycDataHourCount <- reactive({
    count(nycData(), hour_created)
  })
  
  output$table <- renderTable({
    nycDataHourCount()
  })
  
  formatMonth <- reactive({
    month.name[input$month]
  })

  output$selected <- renderText({
    paste(formatMonth(), input$day, input$year)
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
    
      plot_ly(x = nycDataHourCount()$hour_created, y =  nycDataHourCount()$n, type="bar", name=paste(formatMonth(), input$day, input$year)) %>% 
        add_trace(x = nycNoise2016()$hour_created, y = nycNoise2016()$mean, type = 'scatter', mode = 'lines',
                line = list(color = '#45171D'), name="average") %>% 
        add_trace(x = nycNoise2016()$hour_created, y = nycNoise2016()$max, type = 'scatter', mode = 'lines',
                  line = list(color = '#45171D', dash='dash'), name="max") %>% 
        add_trace(x = nycNoise2016()$hour_created, y = nycNoise2016()$min, type = 'scatter', mode = 'lines',
                  line = list(color = '#45171D', dash='dash'), name="min") %>% 
        layout(xaxis = xaxis, yaxis = yaxis)
  })
  
  
  output$map <- renderLeaflet({
    pal <- colorFactor(c("#003432", "#AC1C18", "#191C59", "#2E0239", "#F7B500",  "#0B1AAA"), 
                       domain = c("Queens", "Brooklyn", "Staten Island", "Manhattan", "Bronx", "Long Island"))
    leaflet(data = nycData()) %>% 
      addTiles() %>%
      addCircleMarkers(~long, ~lat, label = ~as.character(borough), color = ~pal(borough), radius = 4, fillOpacity = 0.5) %>% 
      addLegend("bottomright", pal = pal, values = ~borough,
                title = "Boroughs",
                opacity = 1
      )
  })

})
