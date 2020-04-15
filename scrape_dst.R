library(rvest)


# URL des Data Science Teams am Unispital Basel
url <- "https://dkf.unibas.ch/de/ueber-uns/teams/team-data-science/"


# Wer arbeitet denn dort?
read_html(url) %>% 
  html_nodes("h5") %>% 
  html_text()


## Schritt für Schritt:
# 1. HTML Seite lesen und in ein XML Dokument überführen
content <- read_html(url)
class(content)
content


# 2. alle H5 Überschriften extrahieren...
headings <- html_nodes(content, "h5")
headings


# 3. ...und HTML Elemente entfernen
names <- html_text(headings)
names




## Etwas umfangreicher:
# Extraktion von Kontaktdaten
library(dplyr)
library(tidyr)
library(stringr)

# Kontakt-Informationen
contacts <- read_html(url) %>% 
  html_nodes("p, h5") %>% 
  html_text() %>% 
  matrix(ncol=3, byrow=TRUE, dimnames=list(c(), c("name", "job_title", "phone"))) %>% 
  data.frame() %>% 
  separate(name, into = c("name", "title"), sep = ", ") %>% 
  mutate(phone = str_remove(phone, pattern = "Telefon ")) %>% 
  mutate(phone = str_remove(phone, pattern = "E-Mail"))

str(contacts)
contacts


# Bilder
images <- read_html(url) %>% 
  html_nodes("img")

images

html_attr(images, "src")



# Studienvorlagen
vorlagen <- read_html("https://studienwegweiser.dkfbasel.ch/vorlagen") %>% 
  html_nodes("td") %>% 
  html_text()

vorlagen
