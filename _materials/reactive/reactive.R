library(shiny)

ui <- fluidPage(
  textInput("name", "Wie heisst Du?"),
  textOutput("grüsse")
)

server <- function(input, output, session) {
  string = reactive(input$name)
  
  output$grüsse <- renderText({
    paste0("Hallo ", string(), "!")
  })
}

shinyApp(ui, server)