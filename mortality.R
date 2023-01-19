# Magnifique d'avoir ###########################################################

# all bank hol since 2018, ics file from gov.uk
bankhol <- ic_read(here("allData", "bankhol.ics")) %>%
            select(`DTSTART;VALUE=DATE`, SUMMARY) %>%
            rename(DATE = `DTSTART;VALUE=DATE`)

# Initialize ###################################################################
library(pacman)
p_load(tidyverse, magrittr, here, lubridate, calendar) # data manipulation
p_load(readxl, pdftools, curl, openxlsx, readODS)      # file reading utils

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
          

### > gather a list of tibbles ----
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
# Final end of season  end of February 2019 cumulative uptake data for England 
# on influenza vaccinations given from 1 Sep 2018 to 28 Feb 2019.

vac18 <- read.xlsx(here("allData", "vaccine", "vaccine18.xlsx"), sheet = 3, 
                   rows = c(4:25, 27:48, 50:71), rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T)

colnames(vac18) %<>% paste(vac18[1,], vac18[2,], sep = '_')

vac18 %>%
  tibble() %>%
  slice(1:67) %>%
  filter(substr(.$`X1_Org Code_Org Code`,1,1) == 'Y') %>%
  view()

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
