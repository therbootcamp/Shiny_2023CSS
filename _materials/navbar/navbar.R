ui <- navbarPage(
    title = "Navbar Page",
    tabPanel("Panel A",
             "Das ist Panel A"),
    tabPanel("Panel B",
             "Das ist Panel B"),
    tabPanel("Panel C",
             "Das ist Panel C")
  )


server <- function(input, output, session) {
}

shinyApp(ui, server)
