library(shiny)

ui <- fluidPage(
  br(),
  radioButtons("name", h2("Wo wohnst du?"), choices = c("Lzern", "Zürich", "Basel"), width = "100%"),
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
