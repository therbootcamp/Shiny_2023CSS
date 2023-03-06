library(shiny)

library(dplyr)

library(ggplot2)



verletzungen <- readRDS("daten/verletzungen.RDS")



ui <- navbarPage(
  
  title = "InjuryViewer",
  
  
  
  # Dashboard
  
  tabPanel(title = "Dashboard", icon = icon("chart-bar"),
           
           sidebarLayout(
             
             sidebarPanel(
               
               width = 3,
               
               selectInput("körperteil", label = "Körperteil", choices = unique(verletzungen$körperteil), multiple = TRUE),
               
               sliderInput("alter", label = "Alter", min = 0, max = 110, value = c(15, 65)),
               
               actionButton("diagnose_var", "Diagnosen"),
               
               actionButton("unfallort_var", "Unfallorte"),
               
               actionButton("gegenstand_var", "Gegenstände")
               
             ),
             
             mainPanel(
               
               plotOutput("linienplot"),
               
               plotOutput("lollipop_plot")
               
             )
             
           )),
  
  
  
  # Daten
  
  tabPanel(title = "Daten", icon = icon("clipboard"),
           
           tabsetPanel(
             
             tabPanel(title = "Daten",
                      
                      h2("Aktuelle Daten"),
                      
                      dataTableOutput("daten")
                      
             ),
             
             tabPanel(title = "Upload",
                      
                      h2("Daten hochladen")
                      
             ),
             
             tabPanel(title = "Download",
                      
                      h2("Daten runterladen"))
             
           )),
  
  
  
  # Informationen
  
  navbarMenu(title = "Informationen", icon = icon("info-circle"),
             
             tabPanel(title = "Datensatz",
                      
                      fluidPage(fluidRow(column(6, HTML("<h2>National Electronic Injury Surveillance System (NEISS)</h2><h4>Das National Electronic Injury Surveillance System (NEISS) Datenbank wird seit über 45 Jahren von der Consumer Product Safety Commission (CPSC) betrieben. Ihr Zweck ist die Sammlung von verletzungen, die im Zusammenhang von Konsumprodukten entstehen. Das CPSC nutzt die Daten um eine landesweite in Schätzung von produktabhängigen Verletzungen zu liefern.<br><br>NEISS basiert auf einer landesweit repräsentativen Stichprobe an Krankenhäusern in den Vereinigten Staaten und seinen Territorien. Jedes teilnehmende Krankenhaus berichtet Patienteninformationen für jeden Besuch einer Notfallabteilung. Mit den NEISS-Daten können landesweite Schätzungen von Besuchen in Notfallabteilungen von Krankenhäusern ermittelt werden.<br><br>Der aktuelle Datensatz ist ein Ausschnitt der NEISS-Daten. Die Daten wurden auf das Jahr 2017 begrenzt.<br><br>Mehr Informationen zu NEISS unter <a>https://www.cpsc.gov/Research--Statistics/NEISS-Injury-Data</a></h4>"))))
                      
             ),
             
             tabPanel(title = "About",
                      
                      fluidPage(fluidRow(column(6, HTML("<h2>The R Bootcamp</h2><h4>Die App wurde erstellt von The R Bootcamp im Rahmen des Kurses Dashboards mit Shiny<br><br>Mehr Informationen zu The R Bootcamp unter <a>https://therbootcamp.github.io/</a></h4>"))))
                      
             )
             
  )
  
)



# Define server logic required to draw a histogram

server <- function(input, output) {
  
  daten = reactive({
    
    verletzungen %>%
      
      filter(körperteil %in% input$körperteil,
             
             alter >= input$alter[1],
             
             alter <= input$alter[2])
    
  })
  
  
  
  output$daten <- renderDataTable(verletzungen, options = list(pageLength = 10))
  
  
  
  output$linienplot = renderPlot({
    
    daten() %>%
      
      count(alter, geschlecht, wt = anzahl) %>%
      
      ggplot(aes(x = alter, y = n, col = geschlecht)) +
      
      geom_line(linewidth = 1.5) +
      
      theme_minimal() +
      
      theme(
        
        axis.text = element_text(size = 12),
        
        axis.title = element_text(size = 16),
        
        legend.text = element_text(size = 12),
        
        legend.title = element_text(size = 16),
        
        plot.margin = margin(.5, .5, 1, 1, unit = "cm"),
        
        legend.position = "top"
        
      ) +
      
      scale_color_viridis_d(name = "Geschlecht",
                            
                            option = "G",
                            
                            end = .8) +
      
      labs(x = "Alter",
           
           y = "Geschätzte Anzahl Verletzungen")
    
  })
  
  
  
  lollipop_var = reactiveVal("diagnose")
  
  observeEvent(input$diagnose_var, {
    
    lollipop_var("diagnose")
    
  })
  
  observeEvent(input$unfallort_var, {
    
    lollipop_var("unfallort")
    
  })
  
  observeEvent(input$gegenstand_var, {
    
    lollipop_var("gegenstand")
    
  })
  
  output$lollipop_plot = renderPlot({
    
    daten() %>%
      
      mutate(variable = .data[[lollipop_var()]]) %>%
      
      count(variable, geschlecht, wt = anzahl) %>%
      
      ggplot(aes(x = variable, y = n, col = geschlecht)) +
      
      geom_pointrange(
        
        aes(ymin = 0, ymax = n),
        
        linewidth = 1.2,
        
        size = 1.2,
        
        position = position_dodge(width = .5)
        
      ) +
      
      scale_color_viridis_d(option = "G", end = .8) +
      
      theme_minimal() +
      
      theme(
        
        axis.title.y = element_text(size = 16),
        
        axis.title.x = element_blank(),
        
        axis.text.y = element_text(size = 12),
        
        axis.text.x = element_text(
          
          size = 16,
          
          angle = 45,
          
          hjust = 1
          
        ),
        
        plot.margin = margin(.5, .5, .5, 1, unit = "cm"),
        
        legend.position = "none"
        
      ) +
      
      labs(y = "Geschätzte Anzahl")
    
  })
  
}



# Run the application

shinyApp(ui = ui, server = server)