library(shiny)
library(tidyverse)

ui <- fluidPage(
  fileInput("upload", label = "Upload", 
            multiple = TRUE),
  tableOutput("head")
  )

server <- function(input, output, session) {
  output$head <- renderTable(head(input$upload))
  }

shinyApp(ui, server)