library(shiny)
library(tidyverse)
library(tools)
library(shinyFeedback)
library(viridis)

ui = navbarPage(
  "InjuryViewer",
  tabPanel(
    "Dashboard",
    fluid = TRUE,
    icon = icon("chart-bar"),
    
    sidebarLayout(
      sidebarPanel(
        width = 3,
        plotOutput("körper", height = 550, click = "körper_click"),
        sliderInput("alter", "Alter", min = 0, max = 110, value = c(0, 110)),
        actionButton("diagnose_var", "Diagnosen", width = "32%"),
        actionButton("unfallort_var", "Unfallorte", width = "32%"),
        actionButton("gegenstand_var", "Gegenstände", width = "32%"),
        actionButton("zurücksetzen", "Zurücksetzen", width = "100%")
      ),
      mainPanel(
        plotOutput("linien_plot"),
        plotOutput("lollipop_plot")
      ),
    )
  ),
  
  tabPanel(
    "Daten",
    fluid = TRUE,
    icon = icon("clipboard"),
    tabsetPanel(
      tabPanel(
        title = "Daten",
        h2("Aktuelle daten"),
        dataTableOutput("daten")
      ),
      tabPanel(
        useShinyFeedback(),
        title = "Upload",
        h2("Daten hochladen"),
        h4("Achtung Daten werden überschrieben"),
        br(),
        fileInput(
          inputId = "hochladen",
          label = "Wähle eine Datei aus",
          buttonLabel = "Auswählen"
        )
      ),
      tabPanel(
        title = "Download",
        h2("Daten runterladen"),
        br(),
        downloadButton("herunterladen",
                       "Als .csv herunterladen",
                       style = "font-size:20px")
      )
    )
  ),
  navbarMenu(
    "Informationen",
    icon = icon("info-circle"),
    tabPanel("Datensatz",
             fluidPage(fluidRow(
               column(
                 6,
                 HTML("<h2>National Electronic Injury Surveillance System (NEISS)</h2>
                      <h4>Das National Electronic Injury Surveillance System (NEISS) Datenbank wird seit über 45 Jahren von der Consumer Product Safety Commission (CPSC) betrieben. Ihr Zweck ist die Sammlung von verletzungen, die im Zusammenhang von Konsumprodukten entstehen. Das CPSC nutzt die Daten um eine landesweite in Schätzung von produktabhängigen Verletzungen zu liefern.<br><br>
                      NEISS basiert auf einer landesweit repräsentativen Stichprobe an Krankenhäusern in den Vereinigten Staaten und seinen Territorien. Jedes teilnehmende Krankenhaus berichtet Patienteninformationen für jeden Besuch einer Notfallabteilung. Mit den NEISS-Daten können landesweite Schätzungen von Besuchen in Notfallabteilungen von Krankenhäusern ermittelt werden.<br><br>
                      Der aktuelle Datensatz ist ein Ausschnitt der NEISS-Daten. Die Daten wurden auf das Jahr 2017 begrenzt.<br><br>
                      Mehr Informationen zu NEISS unter <a>https://www.cpsc.gov/Research--Statistics/NEISS-Injury-Data</a></h4>"
                 )
               )
             ))),
    tabPanel("About",
             fluidPage(fluidRow(
               column(6, HTML("<h2>The R Bootcamp</h2>
                      <h4>Die App wurde erstellt von The R Bootcamp im Rahmen des Kurses Dashboards mit Shiny<br><br>
                      Mehr Informationen zu The R Bootcamp unter <a>https://therbootcamp.github.io/</a></h4>"
               ))
             ))),
  )
)

server <- function(input, output, session) {
  
  körper <- readRDS("daten/körper.RDS")
  
  verletzungen = reactiveVal(readRDS("daten/verletzungen.RDS"))
  
  output$körper <- renderPlot({
    körper %>%
      ggplot(aes(x, y, group = id)) +
      geom_polygon() +
      geom_polygon(
        data = körper,
        aes(group = id),
        fill = viridis(5, option = "G", end = .9)[5],
        col = "white") +
      geom_polygon(
        data = körper %>% filter(körperteil %in% körperteile()),
        aes(group = id),
        fill = "red",
        col = "white"
      ) +
      labs(title = "Verletzungen",
           subtitle = "Klicke auf Körperteile") +
      theme_void() +
      theme(
        legend.position = "none",
        plot.title = element_text( 
          hjust = .5, face = 2, size = 24),
        plot.subtitle = element_text(hjust = .5, size = 16)
      )
  }, bg = "transparent")
  
  
  körperteile = reactiveVal()
  
  observeEvent(input$körper_click, {
    points = nearPoints(
      körper,
      input$körper_click,
      xvar = "x",
      yvar = "y",
      addDist = TRUE,
      threshold = 100
    )
    selected = points  %>%
      group_by(körperteil, id) %>%
      summarize(d = quantile(dist_, .1)) %>%
      ungroup() %>%
      arrange(d) %>%
      slice(1) %>%
      pull(körperteil)
    
    if (selected %in% körperteile()) {
      körperteile(körperteile()[körperteile() != selected])
    } else {
      körperteile(c(selected, körperteile()))
    }
  })
  
  
  daten = reactive({
    verletzungen() %>%
      filter(körperteil %in% körperteile(),
             alter >= input$alter[1],
             alter <= input$alter[2])
  })
  
  output$daten = renderDataTable(verletzungen(),
                                 options = list(pageLength = 10))
  
  output$linien_plot = renderPlot({
    
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
  
  
  observeEvent(input$hochladen, {
    endung <- file_ext(input$hochladen$datapath)
    if(endung == "RDS"){
      verletzungen(readRDS(input$hochladen$datapath))
    } else {
      showFeedbackDanger("hochladen", "Nur RDS Dateien können geladen werden!")
      Sys.sleep(3)
    }
    
    on.exit(hideFeedback("hochladen"))
  })
  
  output$herunterladen <- downloadHandler(
    filename = function() {"verletzungen.csv"},
    content = function(file) {write_tsv(verletzungen(), file)}
  )
  
  observeEvent(input$zurücksetzen, {
    
    körperteile(c()) 
    updateSliderInput(inputId = "alter", value = c(0, 110))
    
  })
  
  
}

shinyApp(ui, server)