# Initialize ###################################################################
library(pacman)
p_load(tidyverse, magrittr, janitor, here, lubridate)       # data manipulation
p_load(readxl, pdftools, curl, openxlsx, readODS, calendar) # file reading utils
here::i_am("mortality.R")
# Excess Mortality #############################################################
## EuroMomo, I don't think we need this source ----
## I have a local copy just in case

## ONS ----
## cod means "cause of death" & tot means "total deaths"
tmplink <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2023/publicationfileweek012023.xlsx"

### 2022 ----
tmplink <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2022/publicationfileweek522022.xlsx"
cod22 <- read.xlsx(tmplink, sheet = 6,
                   rows = c(6:59), rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
          select(c(1,5,6)) %>%
          mutate(`Flu Season` = "2022-23", .before = 2)

colnames(cod22) <- c("Week Number", "Series", "Involving", "Due to")

### 2021 ----
tmplink <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2021/publishedweek522021.xlsx"
cod21 <- read.xlsx(tmplink, sheet = 6, 
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

### 2020 ----
### data structure changed due to covid; currently done using part of ONS bulletin
### could also include avg for past five years by `select(2:5)`
tmplink <- "https://www.ons.gov.uk/visualisations/dvc1221/fig2/datadownload.xlsx"
cod20 <- read.xlsx(tmplink, sheet = 1, 
                   rows = c(7:60), rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
          select(3:4) %>%
          mutate(Series = "2020-21", .before = 1) %>%
          mutate(week = row_number(), .before = 1)
colnames(cod20) <- c("Week Number", "Series", "Involving", "Due to")

### historical (2016~2019) ----
### weekly mortality due to J09:J18, nothing about "involving", just "due to"
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

## > gather into a single tibble ----

allvac <- rbind(vac17, vac18, vac19, vac20, vac21, vac22) %>%
          as_tibble() %>%
          mutate(year = 2022:2017, .before = 1) %>%
          mutate_if(is.character, as.numeric)
colnames(allvac) <- c("year",
                      "over65_num", "over65_vac", "over65_pct",
                      "atrisk_num", "atrisk_vac", "atrisk_pct",
                      "pregnt_num", "pregnt_vac", "pregnt_pct",
                      "y2and3_num", "y2and3_vac", "y2and3_pct")

