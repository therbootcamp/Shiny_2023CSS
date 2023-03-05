library(shiny)

ui <- fluidPage(
  br(),
  fileInput("name", h2("Daten-Upload"), 
            buttonLabel = "Suche..", 
            placeholder = "Wähle Datei aus.",
            width = "100%")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
