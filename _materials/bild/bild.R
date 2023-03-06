

ui <- fluidPage(
  imageOutput("bild")
)
server <- function(input, output, session) {
  output$bild <- renderImage({
    list(
      src = "puppies/bernese.jpg",
      width = 400,
      height = 650
    )
  }, deleteFile = FALSE)
} 

shinyApp(ui, server)

