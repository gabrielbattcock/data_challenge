# Gabriel Battcock
# Hospitalistion data UKHSA 

#Reading in 
library(readxl)
library(pacman)
library(dplyr)
library(robvis)
library(stringr)
library(gt)
library(gtsummary)
library(scales)
library(ggrepel)
library(mada)
p_load(tidyverse, knitr, RColorBrewer, kableExtra, ggpubr, ggplot2)

#create data frame for sentinal rate for each season

# 17-18 season
data <- read.csv("2017-18_flu_hospital_data.csv")
week <- data$Week.no
week <- ifelse(week>=40, week-39, week+13)
s_17_18 <- data$sent_rate

# 18-19 season 
path_18_19 <- "2018-19_flu_season_data.xlsx"
df_list_201819 <- list()
sheet_vector_201819 <- path_18_19 %>% excel_sheets()
for (i in 1:length(sheet_vector_201819)) {
  
  df_list_201819[[i]] <- tibble(read_xlsx(path_18_19, sheet_vector_201819[i], skip=7))
}
names(df_list_201819) <- sheet_vector_201819
s_18_19 <- df_list_201819$USISS_Sentinel$`2018-19 Hospital admission (rate)`

# 19-20 season

path_19_20 <- "2019-20_flu_season_data.xlsx"
df_list_201920 <- list()
sheet_vector_201920 <- path_19_20 %>% excel_sheets()
for (i in 1:length(sheet_vector_201920)) {
  
  df_list_201920[[i]] <- tibble(read_xlsx(path_19_20, sheet_vector_201920[i], skip=7))
}
names(df_list_201920) <- sheet_vector_201920
s_19_20 <- df_list_201920$USISS_Sentinel$`Hospital admission (rate)`

#22-23
path <- "2022-Influenza_excl.xlsx"
df_list_2022 <- list()
#Some chicanery
sheet_vector_2022 <- path %>% excel_sheets()
for (i in 1:length(sheet_vector_2022)) {
  
  df_list_2022[[i]] <- tibble(read_xlsx(path, sheet_vector_2022[i], skip=7))
}
names(df_list_2022) <- sheet_vector_2022
s_22_23 <- df_list_2022$`Figure_35__SARI_Watch-hospital` %>% 
  filter(df_list_2022$`Figure_35__SARI_Watch-hospital`$`Week number`<21 | df_list_2022$`Figure_35__SARI_Watch-hospital`$`Week number`>39) %>% 
  pull(3)
#create one data frame for the weeks and rate per year
seasons <- data.frame(week, s_17_18, s_18_19, s_19_20) 

print(df_list_2022$`Figure_35__SARI_Watch-hospital`, n = 52)

#plot all lines on pne plot
ggplot(seasons) +
  geom_line(aes(week, s_17_18, color = '2017-18')) +
  geom_line(aes(week, s_18_19, color = '2018-19')) +
  geom_line(aes(week, s_19_20, color = '2019-20')) +
  geom_line(aes(week, s_22_23, color = '2022-23')) +
  guides(color = guide_legend("Season")) +
  ylab("Influenza cases UK (cases per 100,000)") +
  # xlim(-12, 20)+
  ggtitle("UK influenza cases by year (hospitalisation)") +

  scale_x_discrete(name = "Week",
                   limits = c("40", "41", "42", "43", "44",
                              "45", "46", "47", "48", "49",
                              "50", "51", "52", "1", "2", "3",
                              "4", "5", "6", "7", "8", "9", "10",
                              "11", "12", "13", "14", "15", "16",
                              "17", "18", "19", "20"
                              ))
