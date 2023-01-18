# Magnifique d'avoir ###########################################################

# Initialize ###################################################################

library(pacman)
p_load(tidyverse, magrittr, here, lubridate, calendar) 
# p_load(pdftools, curl, openxlsx, readODS) might need later
# clearly we have very different package-loading habits

# all bank hol since 2018, ics file from gov.uk
bankhol <- ic_read(here("allData", "bankhol.ics")) %>%
  select(`DTSTART;VALUE=DATE`, SUMMARY) %>%
  rename(DATE = `DTSTART;VALUE=DATE`)

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

## ONS, not finished yet, going to sleep now ----

ons_link <- c("https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/birthsdeathsandmarriages/deaths/datasets/weeklyprovisionalfiguresondeathsregisteredinenglandandwales/",
              "2023/publicationfileweek012023.xlsx",
              "2022/ublicationfileweek522022.xlsx",
              "2021/publishedweek522021.xlsx",
              "2020/publishedweek532020.xlsx",
              "2019/publishedweek522019.xls",
              "2018/publishedweek522018withupdatedrespiratoryrow.xls",
              "2017/publishedweek522017.xls",
              "2016/publishedweek522016.xls"
              )
mort <- tibble()

mort <- read.xlsx(paste0(), 
              sheet = x, rows = c(), rowNames = F, colNames = T,
              skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T)
    
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

# ______ Disregard everything below this line ______ ###########################
## Vaccine Uptake ##############################################################
# Final end of season  end of February 2019 cumulative uptake data for England 
# on influenza vaccinations given from 1 Sep 2018 to 28 Feb 2019.

vaccine_18 <- read.xlsx(here("allData", "vaccine", "vaccine18.xlsx"),
                      sheet = 3, rows = c(4:25, 27:48, 50:71), rowNames = F, colNames = T,
                      skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T)

colnames(vaccine_18) %<>% paste(vaccine_18[1,], vaccine_18[2,], sep = '_')

vaccine_18 %>%
  tibble() %>%
  slice(1:67) %>%
  filter(substr(.$`X1_Org Code_Org Code`,1,1) == 'Y') %>%
  view()

## Laboratory Surveillance #####################################################
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

## Community Surveillance ######################################################
# Fit notes issued by GP practices, England, April 2018 to September 2022
# CSV (Episodes with diagnosis and duration)
fitnotes <- read_csv('https://files.digital.nhs.uk/AF/AC228F/gp-fit-note-eng-csv-ep-dur-sep-22.csv')