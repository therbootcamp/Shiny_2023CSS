library(shiny)

ui <- fluidPage(
  br(),
  numericInput("name", h2("Wie gross bist du?"), value = c(180), width = "100%"),
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
