library(rvest)
library(dplyr)
library(ggplot2)

# URL des Robert-Koch-Instituts
url <-
  "https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Fallzahlen.html"


# HTML Seite lesen und in ein XML Dokument ueberfuehren
content <- read_html(url)


# Liste enthaltener Tabellen extrahieren
tables <- content %>% html_table()


# COVID-19 Tabelle aus tables Liste extrahieren
c19_table <- tables[[1]]


# erste Row mit ueberfluessigen Header-Informationen entfernen
c19_table <- c19_table[-1, ]


# column names setzen
names(c19_table) <-
  c("Bundesland",
    "n_Infektionen",     # Anzahl der Infektionen
    "n_Neu_Inf",         # Anzahl Neuinfektionen (im Vgl. zum Vortag)
    "n_Pro_100k",        # Anzahl Infektionen pro 100'000 Einwohner
    "n_Todesfaelle")     # Anzahl Todesfaelle


# quantitative Columns in numerischen Datentyp wandeln
c19_table <- c19_table %>% 
  #mutate_at(vars(starts_with('n_')), funs(as.character(.))) %>% 
  mutate_at(vars(starts_with('n_')), funs(gsub("\\.", "", .))) %>% 
  mutate_at(vars(starts_with('n_')), funs(as.numeric(.)))

# Visualisierungen

# Gesamt-Infektionen
ggplot(data = c19_table[1:16, ]) +
  geom_col(aes(x = n_Infektionen, y = Bundesland)) +
  labs(title = "Gesamt-Infektionen", 
       x = "Infektionen")

# Neuinfektionen
ggplot(data = c19_table[1:16,]) +
  geom_col(aes(x = n_Neu_Inf, y = Bundesland)) +
  labs(title = "Neu-Infektionen",
       subtitle = "Im Vergleich zum Vortag",
       x = "Neu-Infektionen")

# Infektionen pro 100'000 Einwohner
ggplot(data = c19_table[1:16, ]) +
  geom_col(aes(x = n_Pro_100k, y = Bundesland)) +
  labs(title = "Infektionen pro 100'000 Einwohner", 
       x = "Inf pro 100k Einw")

# Todesfaelle
ggplot(data = c19_table[1:16, ]) +
  geom_col(aes(x = n_Todesfaelle, y = Bundesland)) +
  labs(title = "Todesfälle", 
       x = "Anzahl Todesfälle")
