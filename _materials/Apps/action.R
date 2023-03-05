library(shiny)

ui <- fluidPage(
  br(),
  actionButton("name", h2("Zurücksetzen"), 
            width = "100%")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
