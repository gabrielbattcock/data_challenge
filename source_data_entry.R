# INITIALISE ###################################################################
library(pacman)
p_load(tidyverse, knitr, kableExtra, mada, reshape2) # data manipulation
p_load(curl, here, openxlsx, readODS, readxl)        # reading files
p_load(ggrepel, ggpubr, gt, gtsummary, hrbrthemes, 
       RColorBrewer, robvis, scales, wesanderson)    # visualisation

here::i_am("source_data_entry.r")

# COMBINED: RCGP, USISS, GP Swabbing, DataMart #################################
## 2018-19 flu season ----
path_18_19 <- here("allData", "2018-19_flu_season_data.xlsx")
df_list_201819 <- list()
sheet_vector_201819 <- path_18_19 %>% excel_sheets()
for (i in 1:length(sheet_vector_201819)) {
  df_list_201819[[i]] <- tibble(read_xlsx(path_18_19, sheet_vector_201819[i], skip=7))
}
names(df_list_201819) <- sheet_vector_201819

## 2019-20 flu season ----
path_19_20 <- here("allData", "2019-20_flu_season_data.xlsx")
df_list_201920 <- list()
sheet_vector_201920 <- path_19_20 %>% excel_sheets()
for (i in 1:length(sheet_vector_201819)) {
  df_list_201920[[i]] <- tibble(read_xlsx(path_19_20, sheet_vector_201920[i], skip=7))
}
names(df_list_201920) <- sheet_vector_201920

## 2021-22 flu season ----
path <- here("allData", "data_2021.xlsx")
df_list_2021 <- list()
sheet_vector_2021 <- path %>% excel_sheets()
for (i in 1:length(sheet_vector_2021)) {
  df_list_2021[[i]] <- tibble(read_xlsx(path_2021, sheet_vector_2021[i], skip=7))
}
names(df_list_2021) <- sheet_vector_2021

## 2022-23 flu season ----
path <- here("allData", "2022-Influenza_excl.xlsx")
df_list_2022 <- list()

sheet_vector_2022 <- path %>% excel_sheets()
for (i in 1:length(sheet_vector_2022)) {
  
  df_list_2022[[i]] <- tibble(read_xlsx(path, sheet_vector_2022[i], skip=7))
}
names(df_list_2022) <- sheet_vector_2022

# Add some supplementary data from the 2023
path_2023 <- "weekly_report_flu_2023.xlsx"
df_list_2023 <- list()

sheet_vector_2023 <- path_2023 %>% excel_sheets()

for (i in 1:length(sheet_vector_2023)) {
  
  df_list_2023[[i]] <- tibble(read_xlsx(path_2023, sheet_vector_2023[i], skip=7))
}
names(df_list_2023) <- sheet_vector_2023


# PRIMARY CARE #################################################################
primary_care_201718 <- read_csv("allData/gp/2017_2018/gp_consultations_17_18.csv")
primary_care_2021 <- df_list_2021$`Figure 33&34. Primary care`$`ILI rate`[2:53]
primary_care_2022 <- df_list_2022$`Figure_31&32__Primary_care`$`ILI rate`
primary_care_2023 <- df_list_2023$`Figure_31&32__Primary_care`$`ILI rate`
primary_care_total <- tibble(Weeks = c(40:52, 1:20),
                            `2017-18` = as.numeric(primary_care_201718$`GP ILI consulation rates (all ages)`[2:34]),
                            `2018-19` = as.numeric(df_list_201819$RCGP$...3[2:34]),
                            `2019-20` = as.numeric(df_list_201920$RCGP$...4[2:34]),
                            # `2021-22` = c(primary_care_2021[40:52], primary_care_2022[1:20]),
                            # Please note that this includes 2022 week 40 to 2023 week
                            `2022-23` = c(primary_care_2023[39:52], rep(NA, 19))
                            )

## gather into one tibble, ready for vis ----
primary_care_vis <- primary_care_total %>% 
  pivot_longer(cols = 2:5, names_to = "Flu Season", values_to = "Rate") %>%
  mutate(Weeks = ifelse(Weeks>=40, Weeks-39, Weeks+13))

# SWAB DATA ####################################################################
swabs <- read_csv(here("allData", "swab", "2014 - 2021 swab data.csv")) %>% tibble()
swabs <- swabs[,-1] %>% select(-year, -week) 

swab_season17_18 <- swabs %>% slice(175:207)
swab_season18_19 <- swabs %>% slice(227:259)
swab_season19_20 <- swabs %>% slice(279:311)

swab_season22_23 <- tibble(df_list_2022$`Figure_10__Datamart_-_Flu`) %>% 
  slice(14:46)  %>%
  ...

supplement_data_2023 <- df_list_2023$`Figure_10__Datamart_-_Flu`

swab_season22_23[14,2:5] <- supplement_data_2023[27,2:5]

swab_season22_23$flu_A <- rowSums(swab_season22_23[2:4])
colnames(swab_season22_23)[5] = 'flu_B'

swab_season22_23 <- swab_season22_23 %>% select ( flu_A,
                                                  flu_B)

## add id number to plot the data ----
swab_season17_18$id <- 1:nrow(swab_season17_18)
swab_season18_19$id <- 1:nrow(swab_season18_19)
swab_season19_20$id <- 1:nrow(swab_season19_20)
swab_season22_23$id <- 1:nrow(swab_season22_23)

## create 2 data frames for flu type A and B ----
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

typeB <- melt(typeB1, id.vars = 'id', variable.name = 'series')

# HOSPITALISATION ##############################################################
## 2017 ----
data_2017 <- read.csv(here("allData", "2017-18_flu_hospital_data.csv"))
week <- data_2017$Week.no
week <- ifelse(week>=40, week-39, week+13)

## other years ----
hosp_17_18 <- data_2017$sent_rate
hosp_18_19 <- df_list_201819$USISS_Sentinel$`2018-19 Hospital admission (rate)`
hosp_19_20 <- df_list_201920$USISS_Sentinel$`Hospital admission (rate)`
hosp_22_23 <- df_list_2022$`Figure_35__SARI_Watch-hospital` %>% 
  filter( df_list_2022$`Figure_35__SARI_Watch-hospital`$`Week number`>39) %>% 
  pull(3)
nas <- rep(NA, 20)
hosp_22_23 <- c(hosp_22_23, nas)

## gather into one tibble, ready for vis ----
hosp_seasons <- data.frame(week, hosp_17_18, hosp_18_19, hosp_19_20, hosp_22_23) 

# MORTALITY ####################################################################
## 2022 ----
link <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2022/publicationfileweek522022.xlsx"
cod22 <- read.xlsx(link, sheet = 6,
                   rows = c(6:59), rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
          select(c(1,5,6)) %>%
          mutate(`Flu Season` = "2022-23", .before = 2)

colnames(cod22) <- c("Week Number", "Series", "Involving", "Due to")

## 2021 ----
link <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2021/publishedweek522021.xlsx"
cod21 <- read.xlsx(link, sheet = 6, 
                   rows = c(6,7,11,12,15,16,19,20), rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
          drop_na() %>%
          t() %>%
          as_tibble(.name_repair = "unique") %>%
          select(5,6) %>%
          relocate("...6", .before =1) %>%
          mutate("Series" = "2021-22", .before = 1) %>%
          mutate("Week Number" = as.numeric(rownames(.))-1, .before = 1)  %>%
          slice(-1)

colnames(cod21) <- c("Week Number", "Series", "Involving", "Due to")

## 2020 ----
## data structure changed due to covid; currently done using another ONS publication
link <- "https://www.ons.gov.uk/visualisations/dvc1221/fig2/datadownload.xlsx"
cod20 <- read.xlsx(link, sheet = 1, 
                   rows = c(7:60), rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
          select(3:4) %>%
          mutate(Series = "2020-21", .before = 1) %>%
          mutate(week = row_number(), .before = 1)

colnames(cod20) <- c("Week Number", "Series", "Involving", "Due to")

## historical (2016~2019) ----
## weekly mortality due to J09:J18, nothing about "involving", just "due to"
link <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/adhocs/15421numberofdeathsduetoinfluenzaandpneumoniaj09j18andfiveyearaveragebyweekregisteredin2016to2019and2021englandandwales/weeklyaverageinfluenzaandpneumoniadeaths1.xlsx"
historical <- read.xlsx(link, sheet = 4, rows = c(5:57), rowNames = F, colNames = T,
                        skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
              melt(id.vars = 'Week.number', variable.name = 'Series') %>%
              rename("Due to" = value) %>%
              rename("Week Number" = "Week.number") %>%
              mutate("Involving" = NA, .before = 3) %>%
              mutate(across(Series, as.character)) %>%
              mutate(Series = case_when(Series == "2016" ~ "2016-17",
                                        Series == "2017" ~ "2017-18",
                                        Series == "2018" ~ "2018-19",
                                        Series == "2019" ~ "2019-20")) %>%
              as_tibble()

## gather into one tibble, ready for vis ----
mortality_vis <- rbind(cod20, cod21, cod22) %>%
                  as_tibble() %>%
                  mutate(across(c(`Involving`, `Due to`), as.double)) %>%
                  rows_append(historical)  %>%
                  mutate(across(Series, as_factor))

# Vaccine Uptake ###############################################################
# [1] Final end of season cumulative uptake data for England 
#     Because of the CCG->ICB shuffle, the data used were grouped by Local Authority
#     Doesn't matter anyway
# [2] Read from URL where possible. All ODS needs downloading to local,
#     they are referenced using here().

## winter 2022 ----
## only published until end of Nov 2022, not end of season
link <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1125840/UKHSA_seasonal_influenza_vaccine_uptake_LA_November2223.ods"
dest <- curl_download(link, here("allData", "vaccine", "vac22.ods"), quiet = F)
vac22 <- read_ods(dest, sheet = 2, range = "A23:D29", col_names = F) %>%
          slice(-c(4,5)) %>%
          pivot_wider(names_from = "A", 
                      values_from = c("B","C","D"),
                      names_vary = "slowest")
vac22[,10:11] <- vac22[,10:11] + vac22[,13:14]
vac22[,12] <- 100* vac22[,11] / vac22[,10]
vac22 %<>% select(-c(13:15))
colnames(vac22) <- LETTERS[1:12]

## winter 2021 ----
link <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1062488/LA__Seasonal_influenza_vaccine_uptake_GP_patients_February_2122.ods"
dest <- curl_download(link, here("allData", "vaccine", "vac21.ods"), quiet = F)
vac21 <- read_ods(dest, sheet = 2, range = "A22:D33", col_names = F) %>%
          slice(-c(4:8,10,11)) %>%
          pivot_wider(names_from = "A", 
                      values_from = c("B","C","D"),
                      names_vary = "slowest")

vac21[,10:11] <- vac21[,10:11] + vac21[,13:14]
vac21[,12] <- 100* vac21[,11] / vac21[,10]
vac21 %<>% select(-c(13:15))
colnames(vac21) <- LETTERS[1:12]

## winter 2020 ----
link <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/995899/Supplementarytables_LA_2021.ods"
dest <- curl_download(link, here("allData", "vaccine", "vac20.ods"))
vac20 <- read_ods(dest, sheet = 2, range = "A11:R26") %>%
          as_tibble(.name_repair = "unique") %>%
          select(-c(4:6, 10:12, 16:18)) 
vac20 <- cbind(vac20[3,1:9], vac20[9,7:9], vac20[15, 7:9]) %>%
          as_tibble(.name_repair = "unique") %>%
          mutate(across(1:15, as.double))

vac20[,10:11] <- vac20[,10:11] + vac20[,13:14]
vac20[,12] <- 100* vac20[,11] / vac20[,10]
vac20 %<>% select(-c(13:15))
colnames(vac20) <- LETTERS[1:12]

## winter 2019 ----
## in this year only, 2yo and 3yo data are combined
## this means we have to combine it for every other year
link <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/913214/LT_1920_formatted_amended_V4.ods"
dest <- curl_download(link, here("allData", "vaccine", "vac19.ods"))
vac19 <- read_ods(dest, sheet = 2, range = "B12:S21") %>%
          as_tibble(.name_repair = "unique") %>%
          select(-c(4:6, 10:12, 16:18)) 

vac19 <- cbind(vac19[3,1:9], vac19[9,7:9])
colnames(vac19) <- LETTERS[1:12]

## winter 2018 ----
link <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/807777/EndOfSeason_Feb_201819_LA_PHEC_amended100619.xlsx"
vac18 <- read.xlsx(link, sheet = 2, 
                   rows = 12:27, cols = 2:19, rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
          as_tibble(.name_repair = "unique") %>%
          select(-c(1, 4:6, 10:12, 16:18)) 

vac18 <- cbind(vac18[3,1:9], vac18[9,7:9], vac18[15, 7:9]) %>% 
          as_tibble(.name_repair = "unique") %>%
          mutate_if(is.character, as.numeric)

vac18[,10:11] <- vac18[,10:11] + vac18[,13:14]
vac18[,12] <- 100* vac18[,11] / vac18[,10]
vac18 %<>% select(-c(13:15))
colnames(vac18) <- LETTERS[1:12]

## winter 2017 ----
## _1 is over65 and at_risk
## _2 is all pregnant
## _3 is all 2-year-olds
## _4 is all 3-year-olds

link <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/710428/Seasonal_flu_GP_patients_01Sept_2017_31Jan_2018_LA.xlsx"
dest <- curl_download(link, here("allData", "vaccine", "vac17.xlsx"), quiet = F)
vac17_1 <- read.xlsx(dest, sheet = 2, 
                     rows = 156, cols = 7:12, rowNames = F, colNames = F,
                     skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = F)
vac17_2 <- read.xlsx(dest, sheet = 3, 
                     rows = 156, cols = 13:15, rowNames = F, colNames = F,
                     skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T)
vac17_3 <- read.xlsx(dest, sheet = 4, 
                     rows = 156, cols = 13:15, rowNames = F, colNames = F,
                     skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T)
vac17_4 <- read.xlsx(dest, sheet = 5, 
                     rows = 156, cols = 13:15, rowNames = F, colNames = F,
                     skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T)

vac17 <- cbind(vac17_1[,7:12], vac17_2[,13:15], vac17_3[,13:15] + vac17_4[,13:15])
vac17[,12] <- 100* vac17[,11] / vac17[,10]
rm(vac17_1, vac17_2, vac17_3, vac17_4)

colnames(vac17) <- LETTERS[1:12]

## gather into a single tibble, ready for vis ----
allvac <- rbind(vac17, vac18, vac19, vac20, vac21, vac22) %>%
          as_tibble() %>%
          mutate(year = 2022:2017, .before = 1) %>%
          mutate_if(is.character, as.numeric)
colnames(allvac) <- c("year",
                      "over65_num", "over65_vac", "over65_pct",
                      "atrisk_num", "atrisk_vac", "atrisk_pct",
                      "pregnt_num", "pregnt_vac", "pregnt_pct",
                      "y2and3_num", "y2and3_vac", "y2and3_pct")

# next heading #################################################################