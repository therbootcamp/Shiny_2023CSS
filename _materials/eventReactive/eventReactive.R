library(shiny)

ui <- fluidPage(
  textInput("name", "Wie heisst Du?"),
  actionButton("grüsse_mich", "Grüsse mich"),
  textOutput("grüsse")
)

server <- function(input, output, session) {
  string = eventReactive(input$grüsse_mich,
                         {input$name})
  
  output$grüsse <- renderText({
    paste0("Hallo ", string(), "!")
  })
}

shinyApp(ui, server)