library(shiny)
library(readr)

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
})

