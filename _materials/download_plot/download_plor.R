
library(shiny)
library(tidyverse)

covid = read_csv("covid.csv") %>% 
  filter(region %in% c("BS","LU")) %>% 
  mutate(monat = paste0(lubridate::year(datum),"-",lubridate::month(datum))) %>% 
  group_by(region, monat) %>% 
  summarize(anzahl = sum(anzahl)) %>% 
  ungroup() %>% 
  pivot_wider(names_from = region,
              values_from = anzahl) %>% 
  rename(Basel = BS, 
         Luzern = LU)



ui <- fluidPage(
  plotOutput("scatter", brush = "plot_click"),
  downloadLink("download", 
               icon("download",
                 style="font-size:16px;position:relative;
                 top:-394px;right:-96%;color:black"))
)

server <- function(input, output, session) {
  
  near_brush = reactiveVal()
  
  observeEvent(input$plot_click, {
    brushedPoints(covid,
                  input$plot_click,
                  xvar = "Basel",
                  yvar = "Luzern") %>% 
      pull(monat) %>% 
      near_brush()
    })
  
  scatter = reactive({covid %>% 
    ggplot(aes(Basel, Luzern)) +
    geom_point() + 
    geom_text(data = covid %>% 
                filter(monat %in% near_brush()), 
              mapping = aes(label = monat),
              nudge_y = 5000) +
    theme_minimal() +
    labs(title = "Covid Fälle") 
    })
  
  output$scatter <- renderPlot({scatter()})
  
  output$download <- downloadHandler(
    filename = function() { "plot.pdf" },
    content = function(file) {
      ggsave(file, 
             plot = scatter(), 
             device = "pdf")
    })
  
}


shinyApp(ui, server)


