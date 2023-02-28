library(shiny)
ui = fluidPage(textOutput("hello"))
server = function(input, output, session) {
  output$hello = renderText("Hello world!")
  }
shinyApp(ui, server)