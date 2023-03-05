library(shiny)

ui <- fluidPage(
  textInput("name", "Wie heisst Du?"),
  actionButton("grüsse_mich", "Grüsse mich"),
  textOutput("grüsse")
)

server <- function(input, output, session) {
  string = reactiveVal()
  observeEvent(input$grüsse_mich, {
    string(paste0("Hallo ", input$name, "!"))
  })
  
  output$grüsse <- renderText(string())
}

shinyApp(ui, server)
