# Magnifique d'avoir ###########################################################

# all bank hol since 2018, ics file from gov.uk
bankhol <- ic_read(here("allData", "bankhol.ics")) %>%
            select(`DTSTART;VALUE=DATE`, SUMMARY) %>%
            rename(DATE = `DTSTART;VALUE=DATE`)

# Initialize ###################################################################
library(pacman)
p_load(tidyverse, magrittr, janitor, here, lubridate) # data manipulation
p_load(readxl, pdftools, curl, openxlsx, readODS, calendar)      # file reading utils

here::i_am("mortality.R")

# Excess Mortality #############################################################
## EuroMomo, really easy one ----

euromomo <- read_delim(here("allData", "mortality", "euromomo.csv"), delim = ';')
euromomo %<>%
  select(-group) %>%
  mutate(country = str_sub(country, 5,-2)) %>%
  mutate(date = ymd(str_c(str_sub(week, 1,4), "-01-01"))+ 
                weeks(str_sub(week, 6,7)),
         .keep = "unused") %>%
  group_by(country)

ggplot(data=euromomo, aes(x=date, y=zscore, color=country)) +
    geom_point() +
    geom_hline(yintercept = 4, color = 'red')
    # +4 s.d. is defined as "susbtantial increase" 
    ylab("Mortality z-score") +
    ggtitle("Mortality z-score by nation, 2017w03 - 2023w01")
    # it could be much better but that's all i can bother with right now

## ONS ----
## cod means "cause of death" & tot means "total deaths"
ons_link <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/"
years    <- c("2023/publicationfileweek012023.xlsx",
              "2022/publicationfileweek522022.xlsx",
              "2021/publishedweek522021.xlsx",
              "2020/publishedweek532020.xlsx",
              "2019/publishedweek522019.xls",
              "2018/publishedweek522018withupdatedrespiratoryrow.xls",
              "2017/publishedweek522017.xls",
              "2016/publishedweek522016.xls"
              )

### 2022 ----
cod2022 <- read.xlsx(paste0(ons_link, years[2]), sheet = 6,
                     rows = c(6:59), rowNames = F, colNames = T,
                     skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
            select(c(1,5,6))

stopifnot(dim(cod2022) == c(52,3))

### 2021 ----
cod2021 <- read.xlsx(paste0(ons_link, years[3]), sheet = 6, 
                     rows = c(6,7,11,12,15,16,19,20), rowNames = F, colNames = T,
                     skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
            drop_na() %>%
            t() %>%
            as_tibble(.name_repair = "unique") %>%
            mutate(Week.number = as.numeric(rownames(.))-1, .before = 1)  %>%
            select(c(1,5,6))
colnames(cod2021) <- as.character(cod2021[1,])
cod2021 %<>% slice(-1)

stopifnot(dim(cod2021) == c(52,3))

### 2020 ----
### data structure changed due to covid; currently done using part of ONS bulletin
### could also include avg for past five years by `select(2:5)`
tmplink <- "https://www.ons.gov.uk/visualisations/dvc1221/fig2/datadownload.xlsx"
cod2020 <- read.xlsx(tmplink, sheet = 1, 
                     rows = c(7:60), rowNames = F, colNames = T,
                     skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
            select(3:4) %>%
            mutate(week = row_number(), .before = 1)

stopifnot(dim(cod2020) == c(53,3))

### historical (2016~2019) ----
### weekly mortality due to J09:J18, nothing about "involving", just "due to"
link <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/adhocs/15421numberofdeathsduetoinfluenzaandpneumoniaj09j18andfiveyearaveragebyweekregisteredin2016to2019and2021englandandwales/weeklyaverageinfluenzaandpneumoniadeaths1.xlsx"
historical <- read.xlsx(link, sheet = 4, rows = c(5:57), rowNames = F, colNames = T,
                        skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T)

for (i in 2016:2019) {
  name = paste0("cod",i)
  assign(name, tibble(historical[1], NA, historical[i-2014]))
  #stopifnot(dim(name) == c(52,3))
}

{
"https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2023/publicationfileweek012023.xlsx"
"https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2022/publicationfileweek522022.xlsx"
"https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2021/publishedweek522021.xlsx"
"https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2020/publishedweek532020.xlsx"
"https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2019/publishedweek522019.xls"
"https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2018/publishedweek522018withupdatedrespiratoryrow.xls"
"https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2017/publishedweek522017.xls"
"https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/2016/publishedweek522016.xls"
} # fold these full length links just in case 

# 2010 - 2015 also available but we don't care alright
          

### > gather into a list of tibbles ----
allmort <- list(cod2016,cod2017,cod2018,cod2019,cod2020,cod2021,cod2022)
# rbind them and slice by season

### [not useful] Total 2019 ----
destfile <- curl_download(paste0(ons_link, years[5]), destfile = here("allData", "mortality", "2019.xls"))

# the table is wide and contains a mix of  type:date and type:numeric
# am i bovvered though?
suppressWarnings( 
tot2019 <- read_xls(destfile, sheet = 4, range = "A4:BB13", col_types = "guess") %>%
            drop_na("1") %>%
            unite(col = "head", c(`Week number`, `...2`), 
                  na.rm = T, remove = T) %>%
            slice(-1) %>%
            t() %>%
            as_tibble() %>%
            mutate(week = row_number()-1, .before = 1)
)
colnames(cod2019) <- as.character(cod2019[1,])
cod2019 %<>% slice(-1)

stopifnot(dim(cod2019) == c(52,4))

### [not useful] ----
### total deaths registered per week in England and Wales, 2016~2021
tmplink <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/adhocs/14188numberofdeathsregisteredfiveyearaverage20162017201820192020inenglandandwalesbyweek/fiveyearaverageenglandandwales1.xlsx"
tot2018 <- read.xlsx(tmplink, sheet = 3,
                     rows = c(5:57), rowNames = F, colNames = T,)




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

vac20 <- cbind(vac20[3,1:9], vac20[9,7:9], vac20[15, 7:9]) %>% as_tibble(.name_repair = "unique")

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
          mutate_if(is.character,as.numeric)

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
          mutate(season = 2022:2017, .before = 1)
colnames(allvac) <- c("season",
                      "over65_num", "over65_vac", "over65_pct",
                      "atrisk_num", "atrisk_vac", "atrisk_pct",
                      "pregnt_num", "pregnt_vac", "pregnt_pct",
                      "y2and3_num", "y2and3_vac", "y2and3_pct")


## > OR, gather into a list of tibbles ----

# ______ Disregard everything below this line ______ ###########################
# Community Surveillance ######################################################
## Fit notes issued by GP practices, England, Apr 2018 to Sep 2022
# CSV (Episodes with diagnosis and duration)
fitnotes <- read_csv('https://files.digital.nhs.uk/AF/AC228F/gp-fit-note-eng-csv-ep-dur-sep-22.csv')

fitnotes %>%
  mutate(Date = dmy(paste0("01", Date))) %>%
  mutate(Resp = grepl("respiratory", `Diagnosis (ICD10 chapter)`), 
         .before = 3, .keep = "unused") %>%
  group_by(Date, Resp, Duration) %>%
  summarise(mean = mean(`Count of episodes`)) -> fitnotes_sum

# test viz
ggplot(fitnotes_sum, aes(Date, mean)) +
  geom_bar(aes(fill = Resp), position = "dodge", stat = "identity")

# get cumulative num of ppl taking sick leave
# by modelling using normal (or χ2) distribution
sick <- tibble(unique(fitnotes_sum$Date))


hist(rchisq(200,6))



## (done in other script) Laboratory Surveillance #####################################################
# Influenze virus detections reported to FluNet

flunet <- read_csv('/Users/jackliu/Downloads/flunet.csv',) %>%
          tibble() %>%
          select(c(5,6,7,8,10,12,13,15,16,19,20,21))

# flunet %>%
#   mutate(t = ymd_hms(ISO_SDATE)) %>%
#   view()

flunet %>% 
  filter(ORIGIN_SOURCE == 'SENTINEL') -> flunet.sen

# flunet %>% 
#   filter(ORIGIN_SOURCE == 'NONSENTINEL') %>%
#   mutate(t = as.numeric(ISO_YEAR)*100 + as.numeric(ISO_WEEK), .keep = 'unused') -> flunet.non

ggplot(flunet.sen) +
  geom_smooth(aes(x = ISO_SDATE, y = AH1N12009), color=2, method = 'lm') +
  geom_path(aes(x = ISO_SDATE, y = BNOTDETERMINED), color=3)
