# tutorial:
# https://blog.rsquaredacademy.com/web-scraping/

#library(tidyverse)
library(rvest)

url <- "https://www.rki.de/DE/Content/InfAZ/N/Neuartiges_Coronavirus/Fallzahlen.html"

content <- read_html(url)

tables <- content %>% html_table(fill = TRUE)

first_table <- tables[[1]]

first_table <- first_table[-1,]

library(janitor)

first_table <- first_table %>% clean_names()

first_table %>% 
  mutate(lifetime_gross = parse_number(lifetime_gross)) %>% 
  arrange(desc(lifetime_gross)) %>% 
  head(20) %>% 
  mutate(title = fct_reorder(title, lifetime_gross)) %>% 
  ggplot() + geom_bar(aes(y = title, x = lifetime_gross), stat = "identity", fill = "blue") +
  labs(title = "Top 20 Grossing movies in US and Canada",
       caption = "Data Source: Wikipedia ")



first_table %>% 
  mutate(lifetime_gross_2 = parse_number(lifetime_gross_2)) %>% 
  arrange(desc(lifetime_gross_2)) %>% 
  head(20) %>% 
  mutate(title = fct_reorder(title, lifetime_gross_2)) %>% 
  ggplot() + geom_bar(aes(y = title, x = lifetime_gross_2), stat = "identity", fill = "blue") +
  labs(title = "Top 20 Grossing movies in US and Canada",
       caption = "Data Source: Wikipedia ")



second_table <- tables[[2]]

second_table %>% 
  clean_names() -> second_table


second_table %>% 
  mutate(adjusted_gross = parse_number(adjusted_gross)) %>% 
  group_by(year) %>% 
  summarise(total_adjusted_gross = sum(adjusted_gross)) %>% 
  arrange(desc(total_adjusted_gross)) %>% 
  ggplot() + geom_line(aes(x = year,y = total_adjusted_gross, group = 1))

