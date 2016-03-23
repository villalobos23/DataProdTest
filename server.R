
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(datasets)
library(ggplot2)

set.seed(23031990)

shinyServer(function(input, output) {

  getCars <- reactive({
    data("mtcars")
    cars <- mtcars[1:input$cars+1,]
    cars
  })
  
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    #x    <- faithful[, 2]
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    reduced <- getCars()[,c(input$use,input$est)]
    colnames(reduced) <- c("use","est")
    p <- ggplot(reduced,aes(x=use,y=est)) + 
      geom_point() +
      stat_smooth(method = "lm", col = "red")
    print(p)
  })

})
