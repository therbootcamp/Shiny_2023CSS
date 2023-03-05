


ui <- fluidPage(
  titlePanel("Sidebar Layout"),
  sidebarLayout(
    sidebarPanel(), 
    mainPanel(
      fluidRow(
        column(8, 
               tags$a(tags$a(href="www.rstudio.com", 
                             "Click here!"))),
        column(4)
      ),
      fluidRow()
    )))


ui <- tags$html(
  tags$body(
    tags$div(
      tags$p(
        "Das ist ein Link zum", 
        tags$a(href="www.therbootcamp.com", 
               "The R Bootcamp")
        )
      )
    )
  )

server <- function(input, output, session) {
}

shinyApp(ui, server)
