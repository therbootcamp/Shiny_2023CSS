library(shiny)
library(tidyverse)

ui <- fluidPage(
  titlePanel("RDS -> csv"),
  fileInput("upload", NULL, accept = ".RDS"),
  downloadButton("download", label = "Download"))

server <- function(input, output, session){
  daten <- reactive({
    req(input$upload)
    readRDS(input$upload$datapath)})
  output$download <- downloadHandler(
    filename = function() {
      paste0(input$upload$name, ".csv")
    },
    content = function(file) {
      write_csv(daten(), file)
    })
}

shinyApp(ui, server)