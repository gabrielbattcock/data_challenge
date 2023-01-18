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
here::i_am()
#Generate list of tibbles for 2022 data
path <- "2022-Influenza_excl.xlsx"
df_list_2022 <- list()

sheet_vector_2022 <- path %>% excel_sheets()
for (i in 1:length(sheet_vector_2022)) {
  
 df_list_2022[[i]] <- tibble(read_xlsx(path, sheet_vector_2022[i], skip=7))
}
names(df_list_2022) <- sheet_vector_2022



#Some chicanery 2.0
path_18_19 <- "2018-19_flu_season_data.xlsx"
df_list_201819 <- list()
sheet_vector_201819 <- path_18_19 %>% excel_sheets()
for (i in 1:length(sheet_vector_201819)) {
  
  df_list_201819[[i]] <- tibble(read_xlsx(path_18_19, sheet_vector_201819[i], skip=7))
}
names(df_list_201819) <- sheet_vector_201819


#Chicanery 3.0
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

