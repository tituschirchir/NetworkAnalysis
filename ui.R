library(shinydashboard)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("GenerateRGraphs.R")
library(shiny)

dashboardPage(
  dashboardHeader(title = "Contagion Analysis"),
  dashboardSidebar(sidebarMenu(
    menuItem(
      "Graph Analysis",
      tabName = "graph",
      icon = icon("signal")
    ),
    menuItem("Contagion Simulation", tabName = "network", icon = icon("book"))
  )),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "MyStyle.css"),
      tags$link(rel="shortcut icon", href="/www/favicon.ico")
    ),
    tabItems(
    # First tab content
    tabItem(
      tabName = "graph",
      fluidRow(
        box(
          numericInput("assets", label = "Total Value of Assets", value = 10000),
          sliderInput(
            "N",
            "No. Of Banks",
            min = 0,
            max = 100,
            value = 25,
            step = 1
          ),
          sliderInput(
            "prob",
            "Interconnectedness:",
            min = 0,
            max = 1,
            value = 0.2,
            step = 0.01
          ),
          sliderInput(
            "gamma",
            "Capitalization",
            min = 0,
            max = 0.2,
            value = 0.03,
            step = 0.01
          ),
          sliderInput(
            "theta",
            "Interbank Assets to Total Assets Ratio",
            min = 0,
            max = 1,
            value = 0.2,
            step = 0.01
          ) , width=3),
        box(plotOutput("plot",width = 100), class="plotbox"),
        box(radioButtons(
          "variable",
          label = strong("Variable"),
          choices = list(
            "Capitalization" = "G",
            "Interconnectedness" = "P",
            "Interbank Asset to Asset Ratio" = "T",
            "No. of Banks" = "N"
          ),
          selected = "N"
        ),
        sliderInput(
          "simulations",
          "MC Runs",
          min = 0,
          max = 1000,
          value = 100,
          step = 10
        ),
        actionButton("update", "Run MC Simulation", class="action-button2"), width=3),
        box(plotOutput("plot2",width = 100), class="plotbox")
      )
    ),
    
    # Second tab content
    tabItem(
      tabName = "network",
      fluidRow(
        box(
          numericInput("assets2", label = "Total Value of Assets", value = 10000),
          sliderInput(
            "N2",
            "No. Of Banks",
            min = 0,
            max = 100,
            value = 25,
            step = 1
          ),
          sliderInput(
            "prob2",
            "Interconnectedness:",
            min = 0,
            max = 1,
            value = 0.2,
            step = 0.01
          ),
          sliderInput(
            "gamma2",
            "Capitalization",
            min = 0,
            max = 0.2,
            value = 0.03,
            step = 0.01
          ),
          sliderInput(
            "theta2",
            "Interbank Assets to Total Assets Ratio",
            min = 0,
            max = 1,
            value = 0.2,
            step = 0.01
          ),
          actionButton("update2", "Run Simulation", class="action-button2"), width = 3
        ),
        box(numericInput("snapshot", label="Snapshot", value = 0, min = 0, max=100, width = 60),
            plotOutput("plot3", width = 100, height=800), 
            downloadButton('downloadData', 'Download Graph', class="download-button"), class="box-body-custom"
        )
        )
      
    )
  )
  )
)