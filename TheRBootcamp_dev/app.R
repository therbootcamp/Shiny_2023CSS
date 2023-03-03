library(tidyverse)
library(shiny)
library(shinythemes)
library(shinyFeedback)
library(bslib)
library(ggstance)
library(tools)

options(scipen = 10000)

# verletzungen = readRDS("1_data/verletzungen.RDS")

körper = readRDS("1_data/körper.RDS")
körper_farbe = viridis::viridis(5, option = "G", end = .9)[5]

ui = navbarPage(
  "InjuryViewer",
  theme = shinytheme("lumen"),
  
  tabPanel(
    "Dashboard",
    fluid = TRUE,
    icon = icon("chart-bar"),
    
    sidebarLayout(
      sidebarPanel(
        width = 3,
        plotOutput("körper",
                   height = 570,
                   click = "körper_click"),
        htmlOutput("körperteile_text"),
        sliderInput(
          "alter",
          label = "Alter",
          value = c(0, 110),
          min = 0,
          max = 110,
          step = 1
        ),
        actionButton("zurück", "Zurücksetzen", width = "100%")
      ),
      mainPanel(fluidRow(column(
        12, plotOutput("lines")
      )),
      fluidRow(
        column(11, plotOutput("lollipop")),
        column(
          1,
          br(),
          br(),
          br(),
          br(),
          actionButton("diagnose_button", "Diagnosen", width = "100px"),
          br(),
          actionButton("unfallort_button", "Unfallorte", width = "100px"),
          br(),
          actionButton("gegenstand_button", "Gegenstände", width = "100px"),
          br()
        )
      ))
    )
  ),
  
  tabPanel(
    "Daten",
    fluid = TRUE,
    icon = icon("clipboard"),
    tabsetPanel(
      id = "Daten_eingeben",
      tabPanel(title = "Daten",
               h2("Aktuelle daten"),
               dataTableOutput("daten")),
      tabPanel(
        title = "Upload",
        h2("Daten hochladen"),
        h4("Achtung Daten werden überschrieben"),
        br(),
        fileInput(
          inputId = "hochladen",
          label = "Wähle eine Datei aus",
          buttonLabel = "Auswählen"
        ),
        textOutput("hochladen_erfolgreich"),
      ),
      tabPanel(title = "Manuell", {
        fluidPage(
          shinyFeedback::useShinyFeedback(),
          h2("Manuell Daten eingeben"),
          htmlOutput("anzahl_fälle"),
          fluidRow(
            column(
              2,
              radioButtons(
                "körperteil_input",
                HTML("<h3>Körperteil</h3>"),
                choices = character(0),
                selected = character(0)
              )
            ),
            column(
              2,
              radioButtons(
                "diagnose_input",
                HTML("<h3>Diagnose</h3>"),
                choices = character(0),
                selected = character(0)
              )
            ),
            column(
              2,
              radioButtons(
                "unfallort_input",
                HTML("<h3>Unfallort</h3>"),
                choices = character(0),
                selected = character(0)
              )
            ),
            column(
              2,
              radioButtons(
                "gegenstand_input",
                HTML("<h3>Gegenstand</h3>"),
                choices = character(0),
                selected = character(0)
              )
            ),
            column(
              4,
              fluidPage(
                fluidRow(
                  radioButtons(
                    "geschlecht_input",
                    HTML("<h3>Geschlecht</h3>"),
                    choices = character(0),
                    selected = character(0)
                  )
                ),
                fluidRow(selectInput(
                  "alter_input",
                  HTML("<h3>Alter</h3>"),
                  choices = c("Bitte auswählen", 0:120)
                )),
                fluidRow(dateInput(
                  "datum_input", HTML("<h3>Datum</h3>"), value = ""
                )) %>% suppressWarnings(),
                br(),
                br(),
                actionButton("abschicken", "Warte auf Eingabe", style =
                               'font-size:20px')
              )
            )
          )
        )
        
      }),
      tabPanel(
        title = "Download",
        h3("Aktuelle Daten runterladen"),
        br(),
        downloadButton("herunterladen", 
                       label = "Als .csv herunterladen",
                       style = 'font-size:20px')
      )
    )
  ),
  navbarMenu(
    "Informationen",
    icon = icon("info-circle"),
    tabPanel("Datensatz",
             fluidPage(fluidRow(
               column(
                 5,
                 HTML("<h2>National Electronic Injury Surveillance System (NEISS)</h2>
                      <h4>Das National Electronic Injury Surveillance System (NEISS) Datenbank wird seit über 45 Jahren von der Consumer Product Safety Commission (CPSC) betrieben. Ihr Zweck ist die Sammlung von verletzungen, die im Zusammenhang von Konsumprodukten entstehen. Das CPSC nutzt die Daten um eine landesweite in Schätzung von produktabhängigen Verletzungen zu liefern.<br><br>
                      NEISS basiert auf einer landesweit repräsentativen Stichprobe an Krankenhäusern in den Vereinigten Staaten und seinen Territorien. Jedes teilnehmende Krankenhaus berichtet Patienteninformationen für jeden Besuch einer Notfallabteilung. Mit den NEISS-Daten können landesweite Schätzungen von Besuchen in Notfallabteilungen von Krankenhäusern ermittelt werden.<br><br>
                      Der aktuelle Datensatz ist ein Ausschnitt der NEISS-Daten. Die Daten wurden auf das Jahr 2017 begrenzt.<br><br>
                      Mehr Informationen zu NEISS unter <a>https://www.cpsc.gov/Research--Statistics/NEISS-Injury-Data</a></h4>"
                   )
               ),
               column(
                 3,
                 tags$img(src = "https://www.cpsc.gov/sites/default/themes/cpsc/assets/images/cpsc_logo.png", width = "250px")
               )
             ))),
    tabPanel("About",
             fluidPage(fluidRow(
               column(
                 5,
                 HTML("<h2>The R Bootcamp</h2>
                      <h4>Die App wurde erstellt von The R Bootcamp im Rahmen des Kurses Dashboards mit Shiny<br><br>
                      Mehr Informationen zu The R Bootcamp unter <a>https://therbootcamp.github.io/</a></h4>"
                 )
               ),
               column(
                 2,
                 tags$img(src = "https://www.correlaid.org/images/events/therbootcamp_logo.png", width = "250px")
               )
             ))),
  )
)



server <- function(input, output, session) {
  
  # Daten --------
  
  # Lese Basisdatensatz als reactiveVal ein
  verletzungen = reactiveVal(readRDS("1_data/verletzungen.RDS"))
  
  
  # Dashboard ------------------------------------------------
  
  # Körper plot -----
  
  körperteile = reactiveVal()
  
  output$körper <- renderPlot({
    körper %>%
      filter(körperteil == "Silhouette") %>%
      ggplot(aes(x, y)) +
      geom_polygon() +
      geom_polygon(
        data = körper,
        aes(group = id),
        fill = körper_farbe,
        col = "white"
      ) +
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
          hjust = .5,
          face = 2,
          size = 24
        ),
        plot.subtitle = element_text(hjust = .5, size = 16)
      )
  }, bg = "transparent")
  
  
  output$körperteile_text = renderText({
    text = paste(körperteile(), collapse = ", ")
    if (length(körperteile()) > 0) {
      paste0("<p align='center'><b>Ausgewählt</b><br>", text, "</p>")
    }
  })
  
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
  
  
  observeEvent(input$zurück, {
    # setze Körperteile zurück
    körperteile(c())
    
    # setze slider zurück
    updateSliderInput(inputId = "alter", value = c(0, 110))
    
  })
  
  # Linienplot (Häufigkeiten x Alter) -----
  
  data = reactive({
    req(length(names(verletzungen())) > 0)
    verletzungen() %>%
      filter(körperteil %in% körperteile(),
             alter >= input$alter[1],
             alter <= input$alter[2])
  })
  
  
  output$lines = renderPlot({
    if (nrow(data()) > 0) {
      data() %>%
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
      
    } else {
      verletzungen() %>%
        count(alter, geschlecht, wt = anzahl) %>%
        ggplot(aes(x = alter, y = n, col = geschlecht)) +
        theme_minimal() +
        theme(
          axis.text = element_text(size = 12),
          axis.title = element_text(size = 16),
          legend.text = element_text(size = 12),
          legend.title = element_text(size = 16),
          plot.margin = margin(.5, .5, 1, 1, unit = "cm"),
          legend.position = "top",
        ) +
        scale_color_viridis_d(name = "Geschlecht",
                              option = "G",
                              end = .8) +
        labs(x = "Alter",
             y = "Geschätzte Anzahl Verletzungen")
      
    }
    
  })
  
  # Lollipopplot (Häufigkeiten x Variable) -----
  
  lollipop_var = reactiveVal("diagnose")
  observeEvent(input$diagnose_button, {
    lollipop_var("diagnose")
  })
  observeEvent(input$unfallort_button, {
    lollipop_var("unfallort")
  })
  observeEvent(input$gegenstand_button, {
    lollipop_var("gegenstand")
  })
  
  output$lollipop = renderPlot({
    if (nrow(data()) > 0) {
      # Create data
      data() %>%
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
      
    } else
      
      # Create data
      verletzungen() %>%
      mutate(variable = .data[[lollipop_var()]]) %>%
      count(variable, wt = anzahl) %>%
      ggplot(aes(x = variable, y = n)) +
      theme_minimal() +
      theme(
        axis.title.y = element_text(size = 16),
        axis.title.x = element_blank(),
        axis.text = element_text(size = 12),
        axis.text.x = element_text(
          size = 16,
          angle = 45,
          hjust = 1
        ),
        plot.margin = margin(.5, .5, .5, 1, unit = "cm")
      ) +
      labs(y = "Geschätzte Anzahl")
    
  })
  
  
  # Daten ------------------------------------------------
  
  # Daten hochladen ------
  
  
  observeEvent(input$hochladen, {
    endung <- file_ext(input$hochladen$name) %>%
      str_to_lower()
    
    variablen = c(
      "datum",
      "alter",
      "geschlecht",
      "körperteil",
      "diagnose",
      "unfallort",
      "gegenstand",
      "anzahl"
    )
    
    if (endung == "rds") {
      hochgeladene_daten = readRDS(input$hochladen$datapath)
      if (all(variablen %in% names(hochgeladene_daten))) {
        hideFeedback(inputId = "hochladen")
        showFeedbackSuccess(inputId = "hochladen", "Hochladen erfolgreich!")
        verletzungen(hochgeladene_daten)
        output$hochladen_erfolgreich = renderText(paste(
          "Es wurden",
          sum(hochgeladene_daten$anzahl),
          "Fälle geladen!"
        ))
      } else {
        fehlen = variablen[!variablen %in% names(hochgeladene_daten)]
        hideFeedback(inputId = "hochladen")
        showFeedbackDanger(inputId = "hochladen", paste("Variablen fehlen:", paste(fehlen, collapse = ", ")))
      }
    } else {
      showFeedbackWarning(inputId = "hochladen", "Lade RDS oder CSV hoch!")
    }
    
  })
  
  
  # Daten zeigen --------
  
  output$daten = renderDataTable(verletzungen(),
                                 options = list(pageLength = 10))
  
  # Manuell Daten einlesen --------
  
  output$anzahl_fälle = renderText(paste0("Aktuelle Anzahl Fälle: ", sum(verletzungen()$anzahl)))
  
  observe({
    updateRadioButtons(
      inputId = "körperteil_input",
      choices = levels(verletzungen()$körperteil),
      selected = character(0)
    )
    updateRadioButtons(
      inputId = "diagnose_input",
      choices = levels(verletzungen()$diagnose),
      selected = character(0)
    )
    updateRadioButtons(
      inputId = "unfallort_input",
      choices = levels(verletzungen()$unfallort),
      selected = character(0)
    )
    updateRadioButtons(
      inputId = "gegenstand_input",
      choices = levels(verletzungen()$gegenstand),
      selected = character(0)
    )
    updateRadioButtons(
      inputId = "geschlecht_input",
      choices = unique(verletzungen()$geschlecht),
      selected = character(0)
    )
  })
  
  observeEvent(input$abschicken, {
    req(daten_vollständig() == 1)
    
    new = tibble(
      datum = input$datum_input,
      alter = as.numeric(input$alter_input),
      geschlecht = input$geschlecht_input,
      körperteil = factor(
        input$körperteil_input,
        levels = levels(verletzungen()$körperteil)
      ),
      diagnose = factor(input$diagnose_input,
                        levels = levels(verletzungen()$diagnose)),
      unfallort = factor(input$unfallort_input,
                         levels = levels(verletzungen()$unfallort)),
      gegenstand = factor(
        input$gegenstand_input,
        levels = levels(verletzungen()$gegenstand)
      ),
      anzahl = 1
    )
    
    verletzungen(
      verletzungen() %>%
        bind_rows(new) %>%
        group_by(across(-anzahl)) %>%
        summarize(anzahl = sum(anzahl)) %>%
        ungroup()
    )
    
    on.exit({
      Sys.sleep(2)
      daten_vollständig(0)
      updateRadioButtons(inputId = "körperteil_input", selected = character(0))
      updateRadioButtons(inputId = "diagnose_input", selected = character(0))
      updateRadioButtons(inputId = "unfallort_input", selected = character(0))
      updateRadioButtons(inputId = "gegenstand_input", selected = character(0))
      updateRadioButtons(inputId = "geschlecht_input", selected = character(0))
      updateSelectInput(inputId = "alter_input", selected = "Bitte auswählen")
      updateDateInput(inputId = "datum_input", value = "XX") %>% suppressWarnings()
      updateActionButton(inputId = "abschicken", label = "Warte auf Eingabe")
    })
  })
  
  daten_vollständig = reactiveVal()
  
  observe({
    req(length(input$körperteil_input) > 0)
    req(length(input$diagnose_input) > 0)
    req(length(input$unfallort_input) > 0)
    req(length(input$gegenstand_input) > 0)
    req(length(input$geschlecht_input) > 0)
    req(input$alter_input != "Bitte auswählen")
    req(length(input$datum_input) > 0)
    
    updateActionButton(inputId = "abschicken",
                       label = "Fall aufnehmen")
    daten_vollständig(1)
  })
  
  
  # 
  

  output$herunterladen <- downloadHandler(
    filename = function() {
      paste0("verletzungen.csv")
    },
    content = function(file) {
      write_tsv(verletzungen(), file)
    }
  )
  
  
}

shiny::shinyApp(ui, server)
