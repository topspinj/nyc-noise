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
               year_created == input$year)
  })

  output$nycTable <- renderTable({ 
    nycData()
  })
  

  
  output$timePlot <- renderPlotly({
    plot_ly(nycData(), x=~hour_created,
            type = "histogram",
            histnorm = "probability")
  })
  
  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover on a point!" else d
  })
  
  output$info <- renderText({
    xy_str <- function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("x=", round(e$x, 1), " y=", round(e$y, 1), "\n")
    }
    xy_range_str <- function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("xmin=", round(e$xmin, 1), " xmax=", round(e$xmax, 1), 
             " ymin=", round(e$ymin, 1), " ymax=", round(e$ymax, 1))
    }
    
    paste0(
      "click: ", xy_str(input$plot_click)
    )
  })
  
  output$map <- renderLeaflet({
    pal <- colorFactor(c("navy", "red", "dark green", "black", "yellow", "orange"), 
                       domain = c("Queens", "Brooklyn", "Staten Island", "Manhattan", "Bronx", "Long Island"))
    leaflet(data = nycData()) %>% addTiles() %>%
      addCircleMarkers(~long, ~lat, label = ~as.character(borough), color = ~pal(borough), fillOpacity = 0.5)
  })

})
