library(shiny)

ui <- fluidPage(
  textInput("name", "Wie heisst Du?"),
  textOutput("grüsse")
)

server <- function(input, output, session) {
  string = reactiveVal()
  observeEvent(req(input$name), {
    string(paste0("Hallo ", input$name, "!"))
  })
  
  output$grüsse <- renderText(string())
}

shinyApp(ui, server)
