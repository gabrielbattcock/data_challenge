
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

flu_B <- select(data, flu_B, year, week) %>%  pivot_wider(names_from = year,
                                                          values_from = flu_B) %>% rename(
                                                            data_14 = "2014", 
                                                            data_15 = "2015",
                                                            data_16 = "2016", 
                                                            data_17 = "2017",
                                                            data_18 = "2018", 
                                                            data_19 = "2019", 
                                                            data_20 = "2020", 
                                                            data_21 = "2021"
                                                          )

ggplot(flu_A) +
  #geom_point(aes(week, data_14)) + 
  geom_line(aes(week, data_14, color = '2014')) +
  #geom_point(aes(week, data_15)) + 
  geom_line(aes(week, data_15, color = '2015')) +
  #geom_point(aes(week, data_16)) + 
  geom_line(aes(week, data_16, color = '2016')) +
  #geom_point(aes(week, data_17)) + 
  geom_line(aes(week, data_17, color = '2017')) +
  #geom_point(aes(week, data_18)) + 
  geom_line(aes(week, data_18, color = '2018')) +
  #geom_point(aes(week, data_19)) + 
  geom_line(aes(week, data_19, color = '2019')) +
  geom_line(aes(week, data_20, color = '2020')) +
  geom_line(aes(week, data_21, color = '2021')) + 
  guides(color = guide_legend("Year")) +
  ylab("Influenza cases UK (cases)") +
  ggtitle("UK influenza A cases by year (swab testing)")

ggplot(flu_B) +
  #geom_point(aes(week, data_14)) + 
  geom_line(aes(week, data_14, color = '2014')) +
  #geom_point(aes(week, data_15)) + 
  geom_line(aes(week, data_15, color = '2015')) +
  #geom_point(aes(week, data_16)) + 
  geom_line(aes(week, data_16, color = '2016')) +
  #geom_point(aes(week, data_17)) + 
  geom_line(aes(week, data_17, color = '2017')) +
  #geom_point(aes(week, data_18)) + 
  geom_line(aes(week, data_18, color = '2018')) +
  #geom_point(aes(week, data_19)) + 
  geom_line(aes(week, data_19, color = '2019')) +
  geom_line(aes(week, data_20, color = '2020')) +
  geom_line(aes(week, data_21, color = '2021')) + 
  guides(color = guide_legend("Year")) +
  ylab("Influenza cases UK (cases)") +
  ggtitle("UK influenza B cases by year (swab testing)")



