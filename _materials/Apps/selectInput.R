library(shiny)

ui <- fluidPage(
  br(),
  selectInput("name", h2("Wo wohnst du?"), choices = c("Lzern", "Zürich", "Basel"), width = "100%"),
  br(),
  selectInput("name", h2("Wo wohnst du?"), choices = c("Lzern", "Zürich", "Basel"), multiple = TRUE,
              width = "100%")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
