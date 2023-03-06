---
  title: "Wettbewerb"
subtitle: ""
author: "<font style='font-style:normal'>Explorative Datenanalyse</font><br>
<a href='https://therbootcamp.github.io/Shiny_2023CSS/'><i class='fas fa-clock' style='font-size:.9em;' ></i></a>
<a href='https://therbootcamp.github.io'><i class='fas fa-home' style='font-size:.9em;'></i></a>
<a href='mailto:therbootcamp@gmail.com'><i class='fas fa-envelope' style='font-size: .9em;'></i></a>
<a href='https://www.linkedin.com/company/basel-r-bootcamp/'><i class='fab fa-linkedin' style='font-size: .9em;'></i></a>  
<a href='https://therbootcamp.github.io'><font style='font-style:normal'>The R Bootcamp @ CSS</font></a><br>  
<img src='https://raw.githubusercontent.com/therbootcamp/therbootcamp.github.io/master/_sessions/_image/by-sa.png' style='height:15px;width:80px'/>"
output:
  html_document:
  css: practical.css
self_contained: no
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(comment = NA, 
                      fig.width = 6, 
                      fig.height = 6,
                      fig.align = 'center',
                      echo = TRUE, 
                      eval = FALSE, 
                      warning = FALSE,
                      message = FALSE)

options(digits = 3)

library(tidyverse)
covid <- read_csv("data/covid.csv")
```

<p align="center">
  
  <img src="image/dashboard.jpg" width="100%" margin="0"/><br> <font style="font-size:10px">from [unsplash.com](https://unsplash.com/photos/qwtCeJ5cLYs)</font>
  
  </p>
  
  #  {.tabset}
  
  ## Überblick
  
  Zeit eure neuen Skills praktisch anzuwenden. In diesem Teil des Kurses werdet ihr eure Kreativität und Expertise brauchen, um ein COVID-19 Dashboard zu erstellen. Versucht die nützlichsten Interfaces zu erstellen um Usern eures Dashboards die Analyse der Daten zu ermöglichen.

Übrigens, es gibt 🍫🍫🍫 zu gewinnnen.

Der Wettbewerb endet in...

<font style="font-size:32px">
  
  <p id="demo" align="center">
  
  </p>
  
  </font>
  
  ```{=html}
<script>
  // Set the date we're counting down to
var countDownDate = new Date("Mar 8, 2023 16:20:00").getTime();

// Update the count down every 1 second
var x = setInterval(function() {

  // Get todays date and time
  var now = new Date().getTime();

  // Find the distance between now and the count down date
  var distance = countDownDate - now;

  // Time calculations for days, hours, minutes and seconds
  var days = Math.floor(distance / (1000 * 60 * 60 * 24));
  var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
  var seconds = Math.floor((distance % (1000 * 60)) / 1000);

  // Display the result in the element with id="demo"
  document.getElementById("demo").innerHTML = days + "d " + hours + "h "
  + minutes + "m " + seconds + "s ";

  // If the count down is finished, write some text 
  if (distance < 0) {
    clearInterval(x);
    document.getElementById("demo").innerHTML = "EXPIRED";
  }
}, 1000);
</script>
```
<br><br><br>

## Auftrag

Zur Vorbereitung auf die nächste Pandemie sucht das Bundesamt für Gesundheit (BAG) nach geeigneten Online-Tools, um das Infektionsgeschehen im Blick zu behalten. Nun seid ihr gefragt! Es gibt einen Datensatz \`covid.csv\`, dieser stammt vom BAG und enthält wöchentliche Zahlen zu COVID-19 Infektionen in der Schweiz von Februar 2020 bis Februar 2023. Die Infektionszahlen sind sowohl für die gesamte Schweiz als auch pro Kanton verfügbar. Der Datensatz schlüsselt die Infektionszahlen zudem nach Altersgruppen auf.

### A - Vorbereitung

1.  Erstelle einen neuen Ordner `competition` in deinem `TheRBootcamp` Projektordner. 

2.  Erstelle ein neues Skript für deine App und speichere es unter dem Namen `CovidExplorer.R`.

3.  Lade das `shiny` Paket und alle weiteren Pakete, die du verwenden möchtest.

4.  Lade den Datensatz `covid.csv`. Es sollte im `data` Ordner enthalten. Im Tab `Datensatz` findest du Informationen zu den Variablen.  

```{r, eval = FALSE, echo = TRUE}
library(shiny)
library(readr)

covid <- read_csv("covid.csv")

ui <- fluidPage(
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
```

### B - Vorgehen

-   Du bist komplett frei, wie du dein Dashboard gestaltest.

-   Wenn du nach Inspirationen suchst, dann schau mal in den Tab `Inspiration`.

-   Nutze dein neu erlangtes Wissen aus den Übungen der letzten Tage und versuch es in der Praxis anzuwenden.

### C - Wettbewerbsregeln

1.  Das Ziel des Wettbewerbs ist es die **überzeugenste**, **benutzerfreundlichste** und **schönste** Dashboard-App zu erstellen.

2.  Am Wettbewerb teilzunehmen ermöglicht dir die Chance viel 🍫🍫🍫 zu gewinnen.

3.  Die nimmst am Wettbewerb teil indem du deinen Ordner `competition` als `.zip` Datei komprimierst und an uns schickst.

4.  Reiche deine Beitrag ein indem Du deine `.zip` Datei an unsere <a href="mailto:therbootcamp@gmail.com"><b>[therbootcamp\@gmail.com](mailto:therbootcamp@gmail.com){.email}</b></a> Mail Adresse schickst.

5.  Jeder Beitrag wird anonym beurteilt duch eine Jury bestehend aus den Kursteilnehmern und Kursteilnehmerinnen. Der Beitrag mit den meisten Punkten gewinnt. Die Beurteilung findet im Anschluss an den Kurs statt.

Wichtig: Entscheidend für den Erfolg sind verschiedene Faktoren: Benutzerfreundlichkeit, Funktionsumfang, Erkenntnisgewinn, Aussehen, usw.

## Rating

Wir machen alle eingereichten Dashboards online verfügbar. Danach bekommt ihr einen Link zu einem Fragebogen in dem ihr abstimmen, welches Dashboard Schokolade gewinnt.

## Inspiration

### Visualisierungen


1. XXX

```{r, eval = TRUE, echo = TRUE}

covid %>% 
  group_by(region, datum) %>% 
  summarise(anzahl = sum(anzahl), 
            summe = sum(summe), 
            population = sum(population, na.rm = TRUE)) %>% 
  filter(region == "CH") %>% 
  ggplot(aes(x = datum, y = anzahl)) +
  geom_col(fill = "#ff0000") +
  labs(title = "COVID-19 Fälle pro Woche", subtitle = "ganze Schweiz") +
  xlab("Datum") +
  ylab("Fälle pro Woche") +
  theme_minimal()

```

2. XXX

```{r, eval = TRUE, echo = TRUE}

covid %>% 
  group_by(region, datum) %>% 
  summarise(anzahl = sum(anzahl), 
            summe = sum(summe), 
            population = sum(population, na.rm = TRUE)) %>% 
  mutate(pro_kopf = anzahl / population) %>% 
  filter(region %in% c("FR", "LU")) %>% 
  ggplot(aes(x = datum, y = pro_kopf, fill = region)) +
  geom_col(position = "dodge") +
  scale_fill_manual(values = c("FR" = "black", "LU" = "#1e8ccd"), name = "Kanton") +
  labs(title = "COVID-19 Fälle pro Kopf") +
  xlab("Datum") +
  ylab("Fälle pro Woche pro Kopf") +
  theme_minimal()

```



### Layout

![Beispiel für Inputs und Outputs](image/slider-plot.png){style="width: 75%;"}

### Layouts

![Farben und Layout Entwurf](image/color-layout.png){style="width: 75%;"}

## Datensatz



| Name           | Bedeutung                                                                                                            |
|:-----------------------|:-----------------------------------------------|
| `altersgruppe` | Altersgruppe, auf die sich die Daten in dieser Zeile beziehen.                                                       |
| `region`       | Region auf die sich die Daten in dieser Zeile beziehen. `CH` oder einer von 26 Kantonen.                             |
| `datum`        | Datum, an dem die Woche beginnt, für welche diese Zeile Daten liefert.                                               |
| `anzahl`       | Anzahl COVID-19 Fälle, welche in dieser Woche in dieser Region für diese Altersgruppe gemeldet wurden.               |
| `summe`        | Anzahl COVID-19 Fälle, welche bis zu dieser Woche in dieser Region für diese Altersgruppe insgesamt gemeldet wurden. |
| `population`   | Anzahl Personen in dieser Region und dieser Altersgruppe.                                                            |
