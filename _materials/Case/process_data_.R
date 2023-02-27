injuries <- read_tsv("../_materials/Case/injuries.tsv")
products <- read_tsv("../_materials/Case//products.tsv")
population <- read_tsv("../_materials/Case//population.tsv")

verletzungen = injuries %>% 
  select(-race, -narrative) %>% 
  rename(datum = trmt_date, 
         alter = age, 
         geschlecht = sex, 
         körperteil = body_part,
         unfallort = location,
         diagnose = diag, 
         gegenstand_nr = prod_code, 
         gewicht = weight) %>% 
  mutate(
    geschlecht = case_when(
      geschlecht == "male" ~ "männlich",
      geschlecht == "female" ~ "weiblich"),
    körperteil = case_when(
      körperteil == "25 - 50% Body" ~ "25-50% des Körpers",
      körperteil == "All Of Body" ~ "Gesamter Körper",
      körperteil == "Ankle" ~ "Fussgelenk",
      körperteil == "Ear" ~ "Ohr",
      körperteil == "Elbow" ~ "Ellbogen",
      körperteil == "Eyeball" ~ "Augapfel",
      körperteil == "Face" ~ "Gesicht",
      körperteil == "Finger" ~ "Finger",
      körperteil == "Foot" ~ "Fuss",
      körperteil == "Hand" ~ "Hand",
      körperteil == "Head" ~ "Kopf",
      körperteil == "Internal" ~ "Intern",
      körperteil == "Knee" ~ "Knie",
      körperteil == "Lower Arm" ~ "Unterarm",
      körperteil == "Lower Leg" ~ "Unterschenkel",
      körperteil == "Lower Trunk" ~ "Unterer Oberkörper",
      körperteil == "Mouth" ~ "Mund",
      körperteil == "N.S./Unk" ~ "Nicht bekannt",
      körperteil == "Neck" ~ "Hals",
      körperteil == "Pubic Region" ~ "Schamgegend",
      körperteil == "Shoulder" ~ "Schulter",
      körperteil == "Toe" ~ "Zehen",
      körperteil == "Upper Arm" ~ "Oberarm",
      körperteil == "Upper Leg" ~ "Oberschenkel",
      körperteil == "Wrist" ~ "Handgelenk",
      körperteil == "Upper Trunk" ~ "Oberer Oberkörper"),
    unfallort = case_when(
      unfallort == "Farm" ~ "Bauernhof",
      unfallort == "Home" ~ "Zuhause",
      unfallort == "Industrial Place" ~ "Industrieanlage",
      unfallort == "Mobile Home" ~ "Wohnwagen",
      unfallort == "Other Public Property" ~ "Öffentlicher Ort",
      unfallort == "School" ~ "Schule",
      unfallort == "Sports Or Recreation Place" ~ "Sportanlage",
      unfallort == "Street Or Highway" ~ "Strasse",
      unfallort == "Unknown" ~ "Unbekannt"),
    diagnose = case_when(
      diagnose == "Amputation" ~ "Amputation",
      diagnose == "Anoxia" ~ "Sauerstoffmangel",
      diagnose == "Aspirated Object" ~ "Eingeatmetes Objekt",
      diagnose == "Avulsion" ~ "Avulsion",
      diagnose == "Burns, Chemical" ~ "Verbrennung",
      diagnose == "Burns, Elec" ~ "Verbrennung",
      diagnose == "Burns, Not Spec" ~ "Verbrennung",
      diagnose == "Burns, Radiation" ~ "Verbrennung",
      diagnose == "Burns, Scald" ~ "Verbrennung",
      diagnose == "Burns, Thermal" ~ "Verbrennung",
      diagnose == "Concussion" ~ "Gehirnerschütterung",
      diagnose == "Contusion Or Abrasion" ~ "Prellung",
      diagnose == "Crushing" ~ "Quetschverletzung",
      diagnose == "Dental Injury" ~ "Zahnverletzung",
      diagnose == "Dermat Or Conj" ~ "Hautverletzung",
      diagnose == "Dislocation" ~ "Ausrenkung",
      diagnose == "Electric Shock" ~ "Elektr. Schock",
      diagnose == "Foreign Body" ~ "Fremdkörper",
      diagnose == "Fracture" ~ "Knochenbruch",
      diagnose == "Hematoma" ~ "Hämatom",
      diagnose == "Hemorrhage" ~ "Einblutung",
      diagnose == "Ingested Object" ~ "Verschlucktes Objekt",
      diagnose == "Inter Organ Injury" ~ "Verletzung innerer Organe",
      diagnose == "Laceration" ~ "Schnittwunde",
      diagnose == "Nerve Damage" ~ "Nervenschädigung",
      diagnose == "Other Or Not Stated" ~ "Unbekannt",
      diagnose == "Poisoning" ~ "Vergiftung",
      diagnose == "Puncture" ~ "Stichwunde",
      diagnose == "Strain, Sprain" ~ "Verstauchung",
      diagnose == "Submersion" ~ "Ertrinken")) 


gegenstände = products %>% 
  rename(gegenstand_nr = prod_code,
         gegenstand = title) %>% 
  mutate(gegenstand = case_when(
    gegenstand == "knives, not elsewhere classified" ~ "Messer",
    gegenstand == "tableware and accessories" ~ "Geschirr/Besteck",
    gegenstand == "desks, chests, bureaus or buffets" ~ "Schreibtisch/Truhe",
    gegenstand == "bathtubs or showers" ~ "Badewannen/Duschen",
    gegenstand == "toilets" ~ "Toilette",
    gegenstand == "rugs or carpets, not specified" ~ "Teppich",
    gegenstand == "sofas, couches, davenports, divans or st" ~ "Sofa",
    gegenstand == "containers, not specified" ~ "Behälter",
    gegenstand == "sports or recreational activity, n.e.c." ~ "Sport/Freizeitaktivität",
    gegenstand == "basketball (activity, apparel or equip.)" ~ "Basketball",
    gegenstand == "football (activity, apparel or equip.)" ~ "Football",
    gegenstand == "trampolines" ~ "Trampolin",
    gegenstand == "slides or sliding boards" ~ "Rutsche",
    gegenstand == "monkey bars or other playground climbing" ~ "Klettergerüst / Klettern",
    gegenstand == "soccer (activity, apparel or equip.)" ~ "Fussball",
    gegenstand == "skateboards" ~ "Skateboards",
    gegenstand == "footwear" ~ "Schuhwerk",
    gegenstand == "jewelry" ~ "Schmuck",
    gegenstand == "floors or flooring materials" ~ "Fussboden",
    gegenstand == "porches, balconies, open-side floors or" ~ "Terasse/Balkon",
    gegenstand == "nails, screws, tacks or bolts" ~ "Nagel/Schraube",
    gegenstand == "stairs or steps" ~ "Treppe/Stufen",
    gegenstand == "fences or fence posts" ~ "Zaun/Zaunpfähle",
    gegenstand == "ceilings and walls (part of completed st" ~ "Decke/Wand",
    gegenstand == "doors, other or not specified" ~ "Tür",
    gegenstand == "windows & window glass, excl storm windo" ~ "Fenster/Fensterglas",
    gegenstand == "weight lifting (activity, apparel or equ" ~ "Gewichtheben",
    gegenstand == "swimming (activity, apparel or equipment" ~ "Schwimmen",
    gegenstand == "exercise (activity or apparel, w/o equip" ~ "Bewegung",
    gegenstand == "furniture, not specified" ~ "Möbel",
    gegenstand == "cabinets, racks, room dividers and shelv" ~ "Schrank/Regal",
    gegenstand == "tables, not elsewhere classified" ~ "Tisch",
    gegenstand == "chairs, other or not specified" ~ "Stuhl",
    gegenstand == "beds or bedframes, other or not spec" ~ "Bett/Bettgestell",
    gegenstand == "ladders, other or not specified" ~ "Leiter",
    gegenstand == "softball (activity, apparel or equipment" ~ "Softball",
    gegenstand == "bicycles and accessories (excl mountain" ~ "Fahrrad/Fahradzubehör",
    gegenstand == "baseball (activity, apparel or equipment" ~ "Baseball"
  ))


verletzungen = verletzungen %>% 
  left_join(gegenstände) %>% 
  select(-gegenstand_nr)

diagnose_levels = verletzungen %>% 
  count(diagnose, wt = gewicht, sort = TRUE) %>% 
  pull(diagnose)

unfallort_levels = verletzungen %>% 
  count(unfallort, wt = gewicht, sort = TRUE) %>% 
  pull(unfallort)
  
gegenstand_levels = verletzungen %>% 
  count(gegenstand, wt = gewicht, sort = TRUE) %>% 
  pull(gegenstand)

verletzungen = verletzungen %>% 
  mutate(körperteil = factor(körperteil),
         diagnose = factor(diagnose, diagnose_levels),
         unfallort = factor(unfallort, unfallort_levels),
         gegenstand = factor(gegenstand, gegenstand_levels))
  
verletzungen = verletzungen %>% 
  count(datum, alter, geschlecht, körperteil, diagnose, unfallort, gegenstand,
        wt = gewicht, name = "anzahl") %>% 
  mutate(anzahl = round(anzahl) - 4)

saveRDS(verletzungen, "1_data/verletzungen.RDS")

