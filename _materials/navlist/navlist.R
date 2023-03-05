
library(shiny)

ui <- fluidPage(
  titlePanel("Tabset Seite"),
  navlistPanel(
    tabPanel("Panel A",
             "Das ist Panel A"
    ),
    tabPanel("Panel B",
             "Das ist Panel B"),
    tabPanel("Panel C",
             "Das ist Panel C")
  )
)

server <- function(input, output, session) {
}

shinyApp(ui, server)
