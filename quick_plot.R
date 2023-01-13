

library(tidyr)
library(mosaicData)
library(janitor)
library(ggplot2)
library(dplyr)

data <- read.csv("2023-01-13PHE_scraped_flus_until_2020_end.csv")

flu_A <- select(data, flu_A, year, week) %>%  pivot_wider(names_from = year,
                     values_from = flu_A) %>% rename(
                       data_14 = "2014", 
                      data_15 = "2015",
                      data_16 = "2016", 
                      data_17 = "2017",
                      data_18 = "2018", 
                      data_19 = "2019", 
                      data_20 = "2020", 
                      data_21 = "2021"
                     )
ggplot(data = flu_A, aes(week, data_15)) +
  geom_point() + geom_line()


