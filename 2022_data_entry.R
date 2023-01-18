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
path <- "//Users/aizazchaudhry/Desktop/CourseNotes/data_challenge/final_dc_project/data_challenge/2022-Influenza_excl.xlsx"

#Some chicanery
sheet_vector <- path %>% excel_sheets()
for (i in 1:length(sheet_vector)) {
  
 df_list[[i]] <- tibble(read_xlsx(path, sheet_vector[i], skip=7))
}
names(df_list) <- sheet_vector
