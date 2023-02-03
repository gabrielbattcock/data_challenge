# INITIALISE ###################################################################
library(pacman)
p_load(tidyverse, knitr, kableExtra, mada, magrittr, 
       RcppRoll, reshape2, spgwr)                           # data manipulation
p_load(curl, here, openxlsx, readODS, readxl)               # reading files
p_load(ggrepel, ggpubr, gt, gtsummary, hrbrthemes, 
       RColorBrewer, robvis, scales, wesanderson)           # visualisation

here::i_am("R_scripts/source_data_entry.r")

# COMBINED: RCGP, USISS, GP Swabbing, DataMart #################################
## 2018-19 flu season ----
path <- here("allData", "2018-19_flu_season_data.xlsx")
df_list_201819 <- list()
sheet_vector_201819 <- path %>% excel_sheets()
for (i in 1:length(sheet_vector_201819)) {
  df_list_201819[[i]] <- tibble(read_xlsx(path, sheet_vector_201819[i], skip=7))
}
names(df_list_201819) <- sheet_vector_201819

## 2019-20 flu season ----
path <- here("allData", "2019-20_flu_season_data.xlsx")
df_list_201920 <- list()
sheet_vector_201920 <- path %>% excel_sheets()
for (i in 1:length(sheet_vector_201819)) {
  df_list_201920[[i]] <- tibble(read_xlsx(path, sheet_vector_201920[i], skip=7))
}
names(df_list_201920) <- sheet_vector_201920

## 2021-22 flu season ----
path <- here("allData", "data_2021.xlsx")
df_list_2021 <- list()
sheet_vector_2021 <- path %>% excel_sheets()
for (i in 1:length(sheet_vector_2021)) {
  df_list_2021[[i]] <- tibble(read_xlsx(path, sheet_vector_2021[i], skip=7))
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

## supplementary data from 2023 season ----
path <- here("allData", "weekly_report_flu_2023.xlsx")
df_list_2023 <- list()
sheet_vector_2023 <- path %>% excel_sheets()
for (i in 1:length(sheet_vector_2023)) {
  
  df_list_2023[[i]] <- tibble(read_xlsx(path, sheet_vector_2023[i], skip=7))
}
names(df_list_2023) <- sheet_vector_2023

# PRIMARY CARE #################################################################
primary_care_201718 <- read_csv(here("allData", "gp", "2017_2018", "gp_consultations_17_18.csv"))
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

## ready for vis ----
primary_care_melted <- melt(primary_care_total,  id.vars = 'Weeks', variable.name = 'series') 

primary_care_melted$id <- rep(1:33,4)

# NEW GP ILI% continuous, by age group #########################################
recent <- read_csv(here("allData", "gp", "ili-by-age-201822.csv"), 
                 col_types = list('i','i','d','d','d','d'))  %>%
        mutate(across(starts_with("age_"), function(x) x/10))
historical <- read_csv(here("allData", "gp", "ili-by-age-201718.csv"), 
                 col_types = list('i','i','d','d','d','d')) %>%
        mutate(across(starts_with("age_"), function(x) x/100))

ili <- rbind(historical, recent) %>%
        mutate(across(3:6, as.double))

# SWAB DATA ####################################################################
swabs <- read_csv(here("allData", "swab", "2014 - 2021 swab data.csv")) %>% 
          as_tibble() %>%
          select(flu_A, flu_B) 

swab_season17_18 <- swabs %>% slice(175:207)
swab_season18_19 <- swabs %>% slice(227:259)
swab_season19_20 <- swabs %>% slice(279:311)

swab_season22_23 <- tibble(df_list_2022$`Figure_10__Datamart_-_Flu`) %>% 
                    slice(14:46)

supplement_data_2023 <- df_list_2023$`Figure_10__Datamart_-_Flu`

swab_season22_23[14,2:5] <- supplement_data_2023[27,2:5]

swab_season22_23$flu_A <- rowSums(swab_season22_23[2:4])
colnames(swab_season22_23)[5] = 'flu_B'

swab_season22_23 %<>% select(flu_A, flu_B)

## add id number to plot the data ----
swab_season17_18$id <- 1:nrow(swab_season17_18)
swab_season18_19$id <- 1:nrow(swab_season18_19)
swab_season19_20$id <- 1:nrow(swab_season19_20)
swab_season22_23$id <- 1:nrow(swab_season22_23)

## create 2 df for flu type A and B ----
typeA1 <- tibble(id = swab_season17_18$id,
                 '17-18' = swab_season17_18$flu_A,
                 '18-19' = swab_season18_19$flu_A,
                 '19-20' = swab_season19_20$flu_A,
                 '22-23' = swab_season22_23$flu_A)

typeA <- melt(typeA1, id.vars = 'id', variable.name = 'series')

typeB1 <- tibble(id = swab_season17_18$id,
                 '17-18' = swab_season17_18$flu_B,
                 '18-19' = swab_season18_19$flu_B,
                 '19-20' = swab_season19_20$flu_B,
                 '22-23' = swab_season22_23$flu_B)

typeB <- melt(typeB1, id.vars = 'id', variable.name = 'series')

## ready for vis ----
swab_vis = list(typeA, typeB)

# HOSPITALISATION ##############################################################
## 2017 ----
data_2017 <- read.csv(here("allData", "hospitalisation", "2017-18_flu_hospital_data.csv"))
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

## ready for vis ----
hosp_vis <- data.frame(week, hosp_17_18, hosp_18_19, hosp_19_20, hosp_22_23)

# MORTALITY ####################################################################
## 2023 ----
link <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2023/publicationfileweek032023.xlsx"
ifelse(file.exists(here("allData", "mortality", "cod23.xlsx")),
       dest <- here("allData", "mortality", "cod23.xlsx"),
       dest <- curl_download(link, here("allData", "mortality", "cod23.xlsx"), quiet = F))
cod23 <- read.xlsx(dest, sheet = 6,
                   rows = c(6:59), rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
          mutate(Series = 2023) %>%
          select(1,9,5,6)

colnames(cod23) <- c("Week Number", "Series", "Involving", "Due to")

cod23  %<>% rbind(tibble("Week Number" = NA, "Series" = NA, "Involving" = NA, "Due to" = NA, 
                         .rows = 16))

## 2022 ----
link <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2022/publicationfileweek522022.xlsx"
ifelse(file.exists(here("allData", "mortality", "cod22.xlsx")),
       dest <- here("allData", "mortality", "cod22.xlsx"),
       dest <- curl_download(link, here("allData", "mortality", "cod22.xlsx"), quiet = F))
cod22 <- read.xlsx(dest, sheet = 6,
                   rows = c(6:59), rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
          mutate(Series = 2022) %>%
          select(1,9,5,6)

colnames(cod22) <- c("Week Number", "Series", "Involving", "Due to")

## 2021 ----
link <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2021/publishedweek522021.xlsx"
ifelse(file.exists(here("allData", "mortality", "cod21.xlsx")),
       dest <- here("allData", "mortality", "cod21.xlsx"),
       dest <- curl_download(link, here("allData", "mortality", "cod21.xlsx"), quiet = F))
cod21 <- read.xlsx(dest, sheet = 6, 
                   rows = c(6,7,11,12,15,16,19,20), rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
          drop_na() %>%
          t() %>%
          as_tibble(.name_repair = "unique")  %>%
          mutate("Series"      = 2021,
                 "Week Number" = as.numeric(rownames(.))-1) %>%
          select(9,8,4,5) %>%
          slice(-1)

colnames(cod21) <- c("Week Number", "Series", "Involving", "Due to")

## 2020 ----
## data structure changed due to covid; currently done using another ONS publication
link <- "https://www.ons.gov.uk/visualisations/dvc1221/fig2/datadownload.xlsx"
ifelse(file.exists(here("allData", "mortality", "cod20.xlsx")),
       dest <- here("allData", "mortality", "cod20.xlsx"),
       dest <- curl_download(link, here("allData", "mortality", "cod20.xlsx"), quiet = F))
cod20 <- read.xlsx(dest, sheet = 1, 
                   rows = c(7:60), rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
          mutate("Week Number" = row_number()) %>%
          select(8,1,3,4)

colnames(cod20) <- c("Week Number", "Series", "Involving", "Due to")

## historical (2016~2019) ----
## weekly mortality due to J09:J18, nothing about "involving", just "due to"
link <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/adhocs/15421numberofdeathsduetoinfluenzaandpneumoniaj09j18andfiveyearaveragebyweekregisteredin2016to2019and2021englandandwales/weeklyaverageinfluenzaandpneumoniadeaths1.xlsx"
ifelse(file.exists(here("allData", "mortality", "historical.xlsx")),
       dest <- here("allData", "mortality", "historical.xlsx"),
       dest <- curl_download(link, here("allData", "mortality", "cod22.xlsx"), quiet = F))
historical <- read.xlsx(dest, sheet = 4, rows = c(5:57), rowNames = F, colNames = T,
                        skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
              melt(id.vars = 'Week.number', variable.name = 'Series') %>%
              as_tibble() %>%
              rename("Due to" = value,
                     "Week Number" = "Week.number") %>%
              mutate(Involving = NA, .before = 3) %>%
              mutate(across(Series, as.character)) %>%
              filter(Series < 2020)

## ready for vis ----
## incl smoothing by rolling average
allmort <- rbind(cod20, cod21, cod22) %>%
            as_tibble() %>%
            mutate(across(c(`Involving`, `Due to`), as.double)) %>%
            rbind(historical)  %>%
            arrange(Series) %>%
            select(-3)

{
w <- gwr.Gauss(c(6,4,2,0), 2)
w <- w / sum(w)
}

mortality_vis <- allmort %>% 
                  mutate(y      = round(as.numeric(Series) + `Week Number`/100 - 0.89, 0),
                         Series = as.factor(paste0(y,"-",y-1999)),
                         Smooth = roll_meanr(`Due to`, weights = w)) %>%
                  filter(`Week Number` >= 40 | `Week Number` <= 20) %>%
                  select(Series, `Due to`, Smooth) %>%
                  slice(-c(1:20)) %>%
                  group_by(Series) %>%
                  mutate(id = as.numeric(1:n()), .before=1)

mortality_vis_list <- mortality_vis %>%
                      group_by(Series) %>%
                      group_split()

# VACCINE UPTAKE ###############################################################
# [1] Final end of season cumulative uptake data for England 
#     Because of the CCG->ICB shuffle, the data used were grouped by Local Authority
#     Doesn't matter anyway
# [2] Read from URL where possible. 
#     All ODS needs downloading to local, they are referenced using here().

vac_label = c("over65_num", "over65_vac", "over65_pct",
              "atrisk_num", "atrisk_vac", "atrisk_pct",
              "pregnt_num", "pregnt_vac", "pregnt_pct",
              "y2and3_num", "y2and3_vac", "y2and3_pct")

## winter 2022 ----
## only published until end of Nov 2022, not end of season
link <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1125840/UKHSA_seasonal_influenza_vaccine_uptake_LA_November2223.ods"
ifelse(file.exists(here("allData", "vaccine", "vac22.ods")),
       dest <- here("allData", "vaccine", "vac22.ods"),
       dest <- curl_download(link, here("allData", "vaccine", "vac22.ods"), quiet = F))

vac22 <- read_ods(dest, sheet = 2, range = "A23:D29", col_names = F) %>%
          slice(-c(4,5)) %>%
          pivot_wider(names_from = "A", 
                      values_from = c("B","C","D"),
                      names_vary = "slowest") %>%
          mutate("y2and3_num" = .[[10]] + .[[13]],
                 "y2and3_vac" = .[[11]] + .[[14]],
                 "y2and3_pct" = y2and3_vac/y2and3_num * 100)  %>%
          select(-c(10:15))
## chaning colname also has the effect of ensuring the data has the right dimension
colnames(vac22) <- vac_label

## winter 2021 ----
link <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1062488/LA__Seasonal_influenza_vaccine_uptake_GP_patients_February_2122.ods"
ifelse(file.exists(here("allData", "vaccine", "vac21.ods")),
       dest <- here("allData", "vaccine", "vac21.ods"),
       dest <- curl_download(link, here("allData", "vaccine", "vac21.ods"), quiet = F))

vac21 <- read_ods(dest, sheet = 2, range = "A22:D33", col_names = F) %>%
          slice(-c(4:8,10,11)) %>%
          pivot_wider(names_from = "A", 
                      values_from = c("B","C","D"),
                      names_vary = "slowest") %>%
          mutate("y2and3_num" = .[[10]] + .[[13]],
                 "y2and3_vac" = .[[11]] + .[[14]],
                 "y2and3_pct" = y2and3_vac/y2and3_num * 100)  %>%
          select(-c(10:15))
colnames(vac21) <- vac_label

## winter 2020 ----
link <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/995899/Supplementarytables_LA_2021.ods"
ifelse(file.exists(here("allData", "vaccine", "vac20.ods")),
       dest <- here("allData", "vaccine", "vac20.ods"),
       dest <- curl_download(link, here("allData", "vaccine", "vac20.ods"), quiet = F))

vac20 <- read_ods(dest, sheet = 2, range = "A11:R26") %>%
          as_tibble(.name_repair = "unique") %>%
          select(-c(4:6, 10:12, 16:18)) 

vac20 <- cbind(vac20[3,1:9], vac20[9,7:9], vac20[15, 7:9]) %>%
          as_tibble(.name_repair = "unique") %>%
          mutate(across(1:15, as.double)) %>%
          mutate("y2and3_num" = .[[10]] + .[[13]],
                 "y2and3_vac" = .[[11]] + .[[14]],
                 "y2and3_pct" = y2and3_vac/y2and3_num * 100) %>%
          select(-c(10:15))

colnames(vac20) <- vac_label

## winter 2019 ----
## in this year only, 2yo and 3yo data are combined
## this means we have to combine it for every other year
link <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/913214/LT_1920_formatted_amended_V4.ods"
ifelse(file.exists(here("allData", "vaccine", "vac19.xlsx")),
       dest <- here("allData", "vaccine", "vac19.xlsx"),
       dest <- curl_download(link, here("allData", "vaccine", "vac19.xlsx"), quiet = F))

vac19 <- read_ods(dest, sheet = 2, range = "B12:S21") %>%
          as_tibble(.name_repair = "unique") %>%
          select(-c(4:6, 10:12, 16:18)) 

vac19 <- cbind(vac19[3,1:9], vac19[9,7:9])
colnames(vac19) <- vac_label

## winter 2018 ----
link <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/807777/EndOfSeason_Feb_201819_LA_PHEC_amended100619.xlsx"
vac18 <- read.xlsx(link, sheet = 2, 
                   rows = 12:27, cols = 2:19, rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
          as_tibble(.name_repair = "unique") %>%
          select(-c(1, 4:6, 10:12, 16:18)) 

vac18 <- cbind(vac18[3,1:9], vac18[9,7:9], vac18[15, 7:9]) %>% 
          as_tibble(.name_repair = "unique") %>%
          mutate_if(is.character, as.numeric) %>%
          mutate("y2and3_num" = .[[10]] + .[[13]],
                 "y2and3_vac" = .[[11]] + .[[14]],
                 "y2and3_pct" = y2and3_vac/y2and3_num * 100) %>%
          select(-c(10:15))

colnames(vac18) <- vac_label

## winter 2017 ----
## _1 is over65 and at_risk
## _2 is all pregnant
## _3 is all 2-year-olds
## _4 is all 3-year-olds

link <- "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/710428/Seasonal_flu_GP_patients_01Sept_2017_31Jan_2018_LA.xlsx"
ifelse(file.exists(here("allData", "vaccine", "vac17.xlsx")),
       dest <- here("allData", "vaccine", "vac17.xlsx"),
       dest <- curl_download(link, here("allData", "vaccine", "vac17.xlsx"), quiet = F))
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

colnames(vac17) <- vac_label

## ready for vis ----
vaccine_vis <- rbind(vac17, vac18, vac19, vac20, vac21, vac22) %>%
                as_tibble() %>%
                mutate(year = 2022:2017, .before = 1) %>%
                mutate_if(is.character, as.numeric)
colnames(vaccine_vis) <- c("year", vac_label)

# Pivotting the df to the most suitable format for plotting
vacc_rate <- select(vaccine_vis, 
                    'Year' = year,
                    'Over 65 year' = over65_pct,
                    '50-65 with clinical risk' = atrisk_pct,
                    'Pregnant women' = pregnt_pct,
                    '2-3 year olds' = y2and3_pct) %>% pivot_longer(-Year) %>% arrange(., Year)

#For age stratification
age_strat_df1 <- read_csv(here("allData", "gp", "ili-by-age-201718.csv"))
age_strat_df2 <- read_csv(here("allData", "gp", "ili-by-age-201822.csv"))

# manually written from PDFs, so needs to have correct decimal point
age_strat_df1$age_15 <- age_strat_df1$age_15/100
age_strat_df1$age_adult <- age_strat_df1$age_adult/100
age_strat_df1$age_65 <- age_strat_df1$age_65/100
age_strat_df1$age_all <- age_strat_df1$age_all/100
# second df is only a tenth away, annoying difference
age_strat_df2$age_15 <- as.numeric(age_strat_df2$age_15)/10
age_strat_df2$age_adult <- as.numeric(age_strat_df2$age_adult)/10
age_strat_df2$age_65 <- as.numeric(age_strat_df2$age_65)/10
age_strat_df2$age_all <- as.numeric(age_strat_df2$age_all)/10

#Table theme
gt_theme_538 <- function(data,...) {
  data %>%
    opt_all_caps()  %>%
    opt_table_font(
      font = list(
        google_font("Chivo"),
        default_fonts()
      )
    ) %>%
    tab_style(
      style = cell_borders(
        sides = "bottom", color = "#00000000", weight = px(2)
      ),
      locations = cells_body(
        columns = everything(),
        # This is a relatively sneaky way of changing the bottom border
        # Regardless of data size
        rows = nrow(data$`_data`)
      )
    )  %>%
    tab_options(
      column_labels.background.color = "white",
      table.border.top.width = px(3),
      table.border.top.color = "#00000000",
      table.border.bottom.color = "#00000000",
      table.border.bottom.width = px(3),
      column_labels.border.top.width = px(3),
      column_labels.border.top.color = "#00000000",
      column_labels.border.bottom.width = px(3),
      column_labels.border.bottom.color = "black",
      data_row.padding = px(3),
      source_notes.font.size = 12,
      table.font.size = 16,
      heading.align = "left",
      ...
    )
}

# REMOVE IRRELEVANT VARS #################################################################
# 
# suppressWarnings({
#   
# rm(primary_care_201718, primary_care_2021, primary_care_2022, 
#    primary_care_2023, primary_care_total, recent, historical)
#   
# rm(swab_season17_18, swab_season18_19, swab_season19_20, 
#    swab_season22_23, swabs, typeA1, typeB1)
# 
# rm(data_2017, week, hosp_17_18, hosp_18_19, hosp_19_20, hosp_22_23)
# 
# rm(sheet_vector_201819, sheet_vector_201920, sheet_vector_2021,
#    sheet_vector_2022, sheet_vector_2023)
# 
# rm(df_list_201819, df_list_201920, df_list_2021,
#    df_list_2022, df_list_2023, supplement_data_2023)
# 
# rm(cod20, cod21, cod22, historical, allmort)
# 
# rm(vac17, vac17_1, vac17_2, vac17_3, vac17_4,
#    vac18, vac19, vac20, vac21, vac22, allvac, vac_label)
# 
# rm(nas, i, dest, path)
# })
