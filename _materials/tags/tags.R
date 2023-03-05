
ui <- tags$html(
  tags$body(
    tags$div(
      tags$p(
        "Hier ist ein Link zum", 
        tags$a(href="www.therbootcamp.com", 
               "The R Bootcamp")
      )
    )
  )
)

server <- function(input, output, session) {
}

shinyApp(ui, server)
