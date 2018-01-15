library(shiny)
library(readr)

data <- read_csv('../data/data_wrangled.csv')

shinyServer(function(input, output) {
  output$nycTable <- renderTable({ 
    if(is.null(data())) {
      return(NULL)
    }
    data
  })
})
