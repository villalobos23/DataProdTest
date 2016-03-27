
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(datasets)
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Variable Selection effect for simple linear regression"),

  
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("cars",
                  "Number of cars:",
                  min = 1,
                  max = 32,
                  value = 15),
      selectInput("use",
                  "Characteristic to use (x)",
                  colnames(mtcars),
                  selected = colnames(mtcars)[1]
                  ),
      selectInput("est",
                  "Characteristic to estimate (y)",
                  colnames(mtcars),
                  selected = colnames(mtcars)[2]
                  ),
      checkboxInput("useIntercept","Use Intercept?")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        type="tabs",
        tabPanel(
          "Plot",
          plotOutput("distPlot")
        ),
        tabPanel(
          "Residuals",
          plotOutput("resPlot")
        ),
        tabPanel(
          "Summary",
          verbatimTextOutput("summary")
        )
      )
    )
  )
))
