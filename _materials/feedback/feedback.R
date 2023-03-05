

library(shiny)
library(tidyverse)
library(shinyFeedback)

ui <- fluidPage(
  useShinyFeedback(),
  textInput("name_in", "Wie heisst du?"),
  textOutput("name_out")
)

server <- function(input, output, session){
  
  observe({
    feedbackDanger("name_in", 
                   nchar(input$name_in)>5,
                   "Der Name ist zu lang")
  })
  
  output$name_out <- renderText({
    
    if(nchar(input$name_in) <= 2){
      validate("Name muss länger als 2 Zeichen sein")
      }
    paste("Du heisst", input$name_in)
  })
  
}

shinyApp(ui, server)