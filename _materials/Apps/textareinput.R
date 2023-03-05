library(shiny)

ui <- fluidPage(
  br(),
  textAreaInput("feedback",h2("Hast du Feedback?"), width = "100%")
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
