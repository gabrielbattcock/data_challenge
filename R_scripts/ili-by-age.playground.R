library(pacman)
p_load(tidyverse, magrittr, here)
here::i_am("gp-ili-age.R")

recent <- read_csv(here("allData", "gp", "ili-by-age-201822.csv"), 
                 col_types = list('i','i','d','d','d','d'))  %>%
        mutate(across(starts_with("age_"), function(x) x/10))

historical <- read_csv(here("allData", "gp", "ili-by-age-201718.csv"), 
                 col_types = list('i','i','d','d','d','d')) %>%
        mutate(across(starts_with("age_"), function(x) x/100))

ili <- rbind(recent, historical)

plot(ili$age_adult, type = 'l')
lines(ili$age_15, col = 'green')
lines(ili$age_65, col = 'blue')
