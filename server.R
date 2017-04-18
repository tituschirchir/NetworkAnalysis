setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(shiny)
source("GenerateRGraphs.R")
# Define server logic required to draw a histogram
function(input, output) {
  reRunSimulation <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = paste("Running", input$simulations, "MC Simulations..."))
        LoadData(
          type = input$variable,
          M = input$simulations,
          N = input$N,
          p = input$prob,
          theta = input$theta,
          gamma = input$gamma, assets = input$assets
        )
      })
    })
  })
  reRunSimulation2 <- reactive({
    # Change when the "update" button is pressed...
    input$update2
    # ...but not for anything else
    isolate({
      GenerateSimulationData(
          N = input$N2,
          p = input$prob2,
          theta = input$theta2,
          gamma = input$gamma2, 
          assets = input$assets2
        )
    })
  })
  output$plot <- renderPlot({
    reRunSimulation()
    PlotMC(input$variable,
           xlab = expression(gamma),
           isLossPlot = F)
  }, height = 400, width = 600)

  output$plot2 <- renderPlot({
    reRunSimulation()
    PlotMC(input$variable,
           xlab = expression(gamma),
           isLossPlot = T)
  }, height = 400, width = 600)

  output$plot3 <- renderPlot({
    reRunSimulation2()  
    dosimulate()
  }, width = 750, height=800)
}
