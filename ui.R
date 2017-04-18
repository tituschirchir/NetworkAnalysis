library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Contagion Analysis"),
  dashboardSidebar(sidebarMenu(
    menuItem(
      "Graph Analysis",
      tabName = "graph",
      icon = icon("dashboard")
    ),
    menuItem("Network Analysis", tabName = "network", icon = icon("th"))
  )),
  dashboardBody(tabItems(
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
          ),
          sliderInput(
            "simulations",
            "MC Runs",
            min = 0,
            max = 1000,
            value = 1,
            step = 100
          ),
          radioButtons(
            "variable",
            label = h3("Input to Vary"),
            choices = list(
              "Interconnectedness" = "P",
              "Capitalization" = "G",
              "Interbank Asset to Asset Ratio" = "T",
              "No. of Banks" = "N"
            ),
            selected = "P"
          ),
          actionButton("update", "Run MC Simulation"), width=2
        ),
        box(plotOutput("plot")),
        box(plotOutput("plot2"))
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
          actionButton("update2", "Run Simulation"), width=2
        ),
        box(plotOutput("plot3", width = 100, height=800))
      )
    )
  )
  )
)