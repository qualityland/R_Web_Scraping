library(rvest)


# URL des Data Science Teams am Unispital Basel
url <- "https://dkf.unibas.ch/de/ueber-uns/teams/team-data-science/"


# Wer arbeitet denn dort?
read_html(url) %>% 
  html_nodes("h5") %>% 
  html_text()


# HTML Seite lesen und in ein XML Dokument ueberfuehren
content <- read_html(url)
class(content)
content


# alle H5 Ueberschriften extrahieren...
headings <- html_nodes(content, "h5")
headings


# ...und HTML Elemente entfernen
names <- html_text(headings)
names



# Extraktion der Kontaktdaten
library(tidyr)
library(stringr)

contacts <- read_html(url) %>% 
  html_nodes("p, h5") %>% 
  html_text() %>% 
  matrix(ncol=3, byrow=TRUE, dimnames=list(c(), c("name", "job_title", "phone"))) %>% 
  data.frame() %>% 
  separate(name, into = c("name", "title"), sep = ", ") %>% 
  mutate(phone = str_replace(phone, pattern = "Telefon ", replacement = "")) %>% 
  mutate(phone = str_replace(phone, pattern = "E-Mail", replacement = ""))

contacts

