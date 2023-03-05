library(shiny)
library(tidyverse)

ui <- fluidPage(
  fileInput("upload", label = "Upload", 
            accept = c(".csv", ".RDS")),
  tableOutput("head")
)

server <- function(input, output, session) {
  daten = reactiveVal()
  observeEvent(input$upload, {
    ext <- tools::file_ext(input$upload$name)
    if(ext == "csv"){
      daten(read_csv(input$upload$datapath))
    } else if(ext == "RDS") {
      daten(readRDS(input$upload$datapath))
    }
  })
  output$head <- renderTable({
    req(input$upload)
    head(daten())
  })
}

shinyApp(ui, server)