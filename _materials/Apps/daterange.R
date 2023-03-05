library(shiny)

ui <- fluidPage(
  br(),
  dateRangeInput("name", h2("Geburtstag circa?"), width = "100%")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
