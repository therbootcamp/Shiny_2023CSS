library(shiny)

ui <- fluidPage(
  br(),
  sliderInput("name", h2("Wie gross bist du?"), value = c(180), min = 0, max = 300, width = "100%"),
  br(),
  sliderInput("name", h2("Wie gross bist du ca.?"), value = c(170, 180), min = 0, max = 300, width = "100%"),
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
