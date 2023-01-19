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
p_load(tidyverse, knitr, RColorBrewer, kableExtra, ggpubr, ggplot2)
here::i_am("source_data_entry.r")
#Generate list of tibbles for 2022 data
path <- "2022-Influenza_excl.xlsx"
df_list_2022 <- list()

sheet_vector_2022 <- path %>% excel_sheets()
for (i in 1:length(sheet_vector_2022)) {
  
 df_list_2022[[i]] <- tibble(read_xlsx(path, sheet_vector_2022[i], skip=7))
}
names(df_list_2022) <- sheet_vector_2022



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
