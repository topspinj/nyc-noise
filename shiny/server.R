library(shiny)
library(readr)

nycNoise <- read_csv('../data/data_wrangled_2016_test.csv')

shinyServer(function(input, output) {
  
  nycData  <- reactive({
    nycNoise %>% 
      filter(borough == input$borough)
  })
  output$nycTable <- renderTable({ 
    nycData()
  })
})

