library(shiny)

ui <- fluidPage(
  br(),
  dateInput("name", h2("Geburtstag?"), width = "100%")
  )

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
