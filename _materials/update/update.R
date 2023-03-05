library(shiny)
library(tidyverse)

ui <- fluidPage(
  
    actionButton("ändern", label = "Radio"),
    br(), br(),
    uiOutput("wohnen")
  )

server <- function(input, output, session){
  
  labels = c("Radio", "Check", "Select")
  uis = c("radioButtons", "checkboxGroupInput", "selectInput")
  
  index <- reactiveVal(1)
  
  observeEvent(input$ändern, {
    index(1 + (index() %% 3))
    updateActionButton(inputId = "ändern", 
                       label = labels[index()])
  })
  
  output$wohnen = renderUI({

      get(uis[index()])(inputId = "wohnen",
                        label = labels[index()],
                        choices = c("Luzern", "Zürich", "Basel"))

  })
  }

shinyApp(ui, server)