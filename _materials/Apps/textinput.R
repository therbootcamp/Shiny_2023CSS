library(shiny)

ui <- fluidPage(
  br(),
  textInput("name", h2("Wie lautet dein Name?"), width = "100%")
  )

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
