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
library(here)
library(reshape2)
p_load(tidyverse, knitr, RColorBrewer, kableExtra, ggpubr, ggplot2, wesanderson, hrbrthemes)
here::i_am("source_data_entry.r")

#2018-19 flu season
path_18_19 <- "2018-19_flu_season_data.xlsx"
df_list_201819 <- list()
sheet_vector_201819 <- path_18_19 %>% excel_sheets()
for (i in 1:length(sheet_vector_201819)) {
  
  df_list_201819[[i]] <- tibble(read_xlsx(path_18_19, sheet_vector_201819[i], skip=7))
}
names(df_list_201819) <- sheet_vector_201819


#Flu season 2019-20
path_19_20 <- "2019-20_flu_season_data.xlsx"
df_list_201920 <- list()
sheet_vector_201920 <- path_19_20 %>% excel_sheets()
for (i in 1:length(sheet_vector_201819)) {
  
  df_list_201920[[i]] <- tibble(read_xlsx(path_19_20, sheet_vector_201920[i], skip=7))
}
names(df_list_201920) <- sheet_vector_201920

#List of tibbles for 2021 data 
path_2021 <- "data_2021.xlsx"
df_list_2021 <- list()
sheet_vector_2021 <- path_2021 %>% excel_sheets()
for (i in 1:length(sheet_vector_2021)) {
  
  df_list_2021[[i]] <- tibble(read_xlsx(path_2021, sheet_vector_2021[i], skip=7))
}
names(df_list_2021) <- sheet_vector_2021

#Generate list of tibbles for 2022 data
path <- "2022-Influenza_excl.xlsx"
df_list_2022 <- list()

sheet_vector_2022 <- path %>% excel_sheets()
for (i in 1:length(sheet_vector_2022)) {
  
  df_list_2022[[i]] <- tibble(read_xlsx(path, sheet_vector_2022[i], skip=7))
}
names(df_list_2022) <- sheet_vector_2022
#Primary care data cleaning
#Some data management to create the flu seasons
primary_care_201718 <- read_csv("allData/gp/2017_2018/gp_consultations_17_18.csv")
primary_care_2021 <- df_list_2021$`Figure 33&34. Primary care`$`ILI rate`[2:53]
primary_care_2022 <- df_list_2022$`Figure_31&32__Primary_care`$`ILI rate`
#This is the tibble we're using
primary_care_total <- tibble(
  Weeks = c(40:52, 1:20),
  `2017-18` = as.numeric(primary_care_201718$`GP ILI consulation rates (all ages)`[2:34]),
  `2018-19` = as.numeric(df_list_201819$RCGP$...3[2:34]),
  `2019-20` = as.numeric(df_list_201920$RCGP$...4[2:34]),
  `2021-22` = c(primary_care_2021[40:52], primary_care_2022[1:20])
)
#Now just creating the final table for data presentation
primary_care_vis <- primary_care_total %>% 
  pivot_longer(cols = 2:5, names_to = "Flu Season", values_to = "Rate") %>%
  mutate(Weeks = ifelse(Weeks>=40, Weeks-39, Weeks+13))

#Creating data for swabs
swabs <- tibble(read_csv(here("allData", "swab", "2014 - 2021 swab data.csv")))
swabs <- swabs[,-1] %>% select(-year, -week) 

swab_season17_18 <- swabs %>% slice(175:207)
swab_season18_19 <- swabs %>% slice(227:259)
swab_season19_20 <- swabs %>% slice(279:311)

swab_season22_23 <- tibble(df_list_2022$`Figure_10__Datamart_-_Flu`) %>% 
  slice(14:46) 

# Add some supplementary data from the 2023
path_2023 <- "weekly_report_flu_2023.xlsx"
df_list_2023 <- list()

sheet_vector_2023 <- path_2023 %>% excel_sheets()

for (i in 1:length(sheet_vector_2023)) {
  
  df_list_2023[[i]] <- tibble(read_xlsx(path_2023, sheet_vector_2023[i], skip=7))
}
names(df_list_2023) <- sheet_vector_2023

supplement_data_2023 <- df_list_2023$`Figure_10__Datamart_-_Flu`

swab_season22_23[14,2:5] <- supplement_data_2023[27,2:5]

swab_season22_23$flu_A <- rowSums(swab_season22_23[2:4])
colnames(swab_season22_23)[5] = 'flu_B'

swab_season22_23 <- swab_season22_23 %>% select ( flu_A,
                                                  flu_B)



# Add id number to plot the data
swab_season17_18$id <- 1:nrow(swab_season17_18)
swab_season18_19$id <- 1:nrow(swab_season18_19)
swab_season19_20$id <- 1:nrow(swab_season19_20)
swab_season22_23$id <- 1:nrow(swab_season22_23)
# Create data frames for 2 separate flu types
typeA1 <- tibble(id = swab_season17_18$id,
                 '17-18' = swab_season17_18$flu_A,
                 '18-19' = swab_season18_19$flu_A,
                 '19-20' = swab_season19_20$flu_A,
                 '22-23' = swab_season22_23$flu_A)

typeA <- melt(typeA1 ,  id.vars = 'id', variable.name = 'series')

typeB1 <- tibble(id = swab_season17_18$id,
                 '17-18' = swab_season17_18$flu_B,
                 '18-19' = swab_season18_19$flu_B,
                 '19-20' = swab_season19_20$flu_B,
                 '22-23' = swab_season22_23$flu_B)

typeB <- melt(typeB1 ,  id.vars = 'id', variable.name = 'series')

### Hospitalisation data

#2017 hospital data data
data_2017 <- read.csv("2017-18_flu_hospital_data.csv")
week <- data_2017$Week.no
week <- ifelse(week>=40, week-39, week+13)

#The season-by-season data
hosp_17_18 <- data_2017$sent_rate
hosp_18_19 <- df_list_201819$USISS_Sentinel$`2018-19 Hospital admission (rate)`
hosp_19_20 <- df_list_201920$USISS_Sentinel$`Hospital admission (rate)`
hosp_22_23 <- df_list_2022$`Figure_35__SARI_Watch-hospital` %>% 
  filter( df_list_2022$`Figure_35__SARI_Watch-hospital`$`Week number`>39) %>% 
  pull(3)
nas <- rep(NA, 20)
hosp_22_23 <- c(hosp_22_23, nas)
#create one data frame for the weeks and hospitalisation rate per year
hosp_seasons <- data.frame(week, hosp_17_18, hosp_18_19, hosp_18_19, hosp_22_23) 