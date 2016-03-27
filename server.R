
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
    mtcars$cyl <- as.factor(mtcars$cyl)
    levels(mtcars$am) <- c("4 Cyl"," 6 Cyl", "8 Cyl")
    mtcars$am <- as.factor(mtcars$am)
    levels(mtcars$am) <- c("Auto","Manual")
    mtcars$gear <- as.factor(mtcars$gear)
    mtcars$vs <- as.factor(mtcars$vs)
    levels(mtcars$vs) <- c("V-Engine","Straight Engine")
    mtcars$carb <- as.factor(mtcars$carb)
    cars <- mtcars[1:input$cars+1,]
    cars
  })
  
  output$distPlot <- renderPlot({
    
    ##Change plot labels
    ##Explain the idea of the app
    ##Documentation 
    ## factor label for lm
    ##http://web.stanford.edu/~cengel/cgi-bin/anthrospace/building-my-first-shiny-application-with-ggplot
    reduced <- getCars()[,c(input$use,input$est)]
    colnames(reduced) <- c("use","est")
    if(is.factor(reduced$use)){
      
      p <- ggplot(reduced,aes(x=use,y=est,fill=use)) +
        geom_boxplot() +
        xlab(input$use)+
        ylab(input$est)+
        guides(fill=guide_legend(title=input$use))
    }else{
      p <- ggplot(reduced,aes(x=use,y=est)) + 
        geom_point() +
        xlab(input$use)+
        ylab(input$est)
      if(input$useIntercept){
        p <- p + stat_smooth(method = "lm", col = "red")
      }else {
        p <- p + stat_smooth(method = "lm", col = "red",formula = y ~ x - 1)
      }
    }
    print(p)
  })

  output$resPlot <- renderPlot({
    reduced <- getCars()[,c(input$use,input$est)]
    colnames(reduced) <- c("use","est")
    if(!is.factor(reduced$est)){
      fit <- lm (est ~ use,data = reduced)
      fit.qnorm = qqnorm(rstandard(fit),plot.it = F)
      plot(fit.qnorm,type = "n",
           xlab = "Normal Scores ", 
           ylab = "Standarized Residuals ")
      points(fit.qnorm)
    }else{
      plot(0,0,
           xlab = "",
           ylab=" ",
           title("Impossible to fit model to estimate factor variable"))
    }
  })
  
  output$summary <- renderPrint({
    dataset <- getCars()
    colnames(dataset[,input$use]) <- "x"
    colnames(dataset[,input$est]) <- "y"
    
    if(input$useIntercept){
      fit <- lm (y ~ x,data = dataset)
    }else{
      fit <- lm (y ~ x-1, data = dataset)
    }
    summary(fit)
  })
})
