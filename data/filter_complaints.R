library(tidyverse)

data <- read_csv('data/311_Service_Requests_from_2010_to_Present.csv')

data <- data %>% 
  filter(Descriptor == 'Loud Music/Party')

write_csv(data, "data/data.csv")