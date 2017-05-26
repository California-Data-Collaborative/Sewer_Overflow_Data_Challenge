library(shiny)
library(ggmap)
library(plotly)
library(leaflet)
library(shiny)
library(shinythemes)
#setwd("F:/Scrap/Waterchallenge/Sewer_Overflow_Data_Challenge/SSO_Data_Files")


#Reading and summarizing data

shinyUI(fluidPage(
  theme = shinytheme("lumen"),
  

    navbarPage("A.R.G.O", id="nav",
    tabPanel("California",leafletOutput(outputId = "main_plot3", height = "900px"),
             tabPanel("Inputcal",
                      tags$head(
                        includeCSS("style.css")
                      ),
                      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                    draggable = TRUE, top = 100, left = 90, right = 30, bottom = "auto",
                                    width = 300, height = "auto",
                                    checkboxInput(inputId = "show_graphs3",
                                                  label = strong("Show Graphs"),
                                                  value = FALSE),
                                    conditionalPanel(condition = "input.show_graphs3 == true",
                                                     h2("Graphs"),
                                                     selectInput("select_graph1", h3("Select Graph"),
                                                                 choices = list("Distribution by Spill Cause",
                                                                                "Consistent Spills","Spill requests by County",
                                                                                "Spill Volume by County")),
                                                     plotlyOutput("calplot",width=600,height=300))
                                                     
                      )
             )
    ),
    tabPanel("County",leafletOutput(outputId = "main_plot", height = "900px"), 
             tabPanel("Input",
                      tags$head(
                        includeCSS("style.css")
                      ),
                      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                    draggable = TRUE, top = 100, left = 90, right = 30, bottom = "auto",
                                    width = 300, height = "auto",
                                    conditionalPanel(condition = "input.show_graphs == false",
                                    h1("Input"),
                                    uiOutput("County")),
                                    checkboxInput(inputId = "show_graphs",
                                                  label = strong("Show Graphs"),
                                                  value = FALSE),
                                    conditionalPanel(condition = "input.show_graphs == true",
                                    h2("Graphs"),selectInput("select_graph2", h3("Select Graph"),
                                                             choices = list("Distribution by Spill Cause",
                                                                            "Spill requests by CS",
                                                                            "Spill Volume by CS",
                                                                            "Spill Volume by Year")),
                                    plotlyOutput("countyplot",width=600,height=300))
                                    )
                      )
            ),
    
    
    
    
    
    
    
    tabPanel("Collection System", leafletOutput(outputId = "main_plot1", height = "900px"),
             tabPanel("InputCS",
                      tags$head(
                        includeCSS("style.css")
                      ),
                      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                    draggable = TRUE, top = 100, left = 90, right = 30, bottom = "auto",
                                    width = 300, height = "auto",
                                    conditionalPanel(condition = "input.show_graphs2 == false",h1("Input"),
                                    uiOutput("CS")),checkboxInput(inputId = "show_graphs2",
                                                                  label = strong("Show Graphs"),
                                                                  value = FALSE),
                                    conditionalPanel(condition = "input.show_graphs2 == true",
                                                     h2("Graphs"),
                                                     selectInput("select_graph", h3("Select Graph"),
                                                                 choices = list("Change in number of spills over the years",
                                                                                "Distribution By Spill Cause", 
                                                                                "Spills By Date",
                                                                                "Analysis of spills")),
                                                     plotlyOutput("CSplot",width=600,height=300))
                                                    
                                    )
                      )
             ),
    
    tabPanel("Tabular Data",tableOutput('table'))
    
    
    
    
    
    
    
    
    
    
  )




              
  )
  
)
