library(shiny)

ui <- fluidPage(
  br(),
  downloadButton("name", h2("Download"), 
               width = "100%")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
