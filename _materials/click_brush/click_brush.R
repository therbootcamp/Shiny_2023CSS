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
  plotOutput("scatter",
             click = "plot_click",
             brush = "plot_brush")
)

server <- function(input, output, session) {

  near_click = reactiveVal()
  near_brush = reactiveVal()
  observeEvent(input$plot_click, {
    nearPoints(covid,
               input$plot_click,
               xvar = "Basel",
               yvar = "Luzern") %>%
      pull(monat) %>%
      near_click()

    print(nearPoints(covid,
                    input$plot_click,
                    xvar = "Basel",
                    yvar = "Luzern", ))
  })

  observeEvent(input$plot_brush, {
    brushedPoints(covid,
                  input$plot_brush,
                  xvar = "Basel",
                  yvar = "Luzern") %>%
      pull(monat) %>%
      near_brush()
  })

  output$scatter <- renderPlot({
    print(near_click())
    covid %>%
      ggplot(aes(Basel, Luzern)) +
      geom_point() +
      geom_text(data = covid %>%
                  filter(monat %in% near_click() |
                           monat %in% near_brush()),
                mapping = aes(label = monat),
                nudge_y = 5000) +
      theme_minimal() +
      labs(title = "Covid Fälle")

  })

}


shinyApp(ui, server)


