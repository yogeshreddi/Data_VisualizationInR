#Shiny UI is used to manipulate your UI to show your graphs/dashboards in a dashboard

library(shinydashboard)

shinyUI(
  dashboardPage(
    dashboardHeader(title = 'R - Project 1'),
    dashboardSidebar(
      sidebarMenu(
        sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                          label = "Search..."),
        menuItem("ggplot2", tabName = "ggplot2" , icon = icon("dashboard")),
        menuItem("plotly", tabName = "plotly" , icon = icon("dashboard")),
        menuItem("gviz", tabName = "gviz" , icon = icon("dashboard"))
      )
      
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName = "ggplot2",
          fluidRow(
            column (12,box(title = "Per capita CO2 emission(Point Chart)",solidHeader = TRUE,
                           background = "navy",width = 12, plotOutput("pointplot", height = 500)))
          )
        ),
        tabItem(
          tabName = "plotly",
          box(
            plotOutput("pointplot", height = 500) 
          )
        ),
        tabItem(
          tabName = "gviz",
          box(
            plotOutput("pointplot", height = 500) 
          )
        )
      )
      
    )
  )
)