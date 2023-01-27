# NOTES ########################################################################

# Since we cannot source() part of a script, I copied some sections from Source_data_entry
# to obtain continuous data, not just w40~w20

# this script use the newly added RCGP ILI data and other data we had before
# and convert them to time-series format using ts()
# they are then de-trended using decompose() then extract $seasonal part
# Being stationary periodic waves, we should be able to run lmtest::gran
# to obtain a matrix of pairwise correlations

# INIT #########################################################################

library(pacman)
p_load(tidyverse, magrittr, here, curl, openxlsx, readODS)
p_load(lmtest)
here::i_am("R_scripts/ili-by-age.R")

# READ DATA ####################################################################

## rcgp ili --------------------------------------------------------------------
recent <- read_csv(here("allData", "gp", "ili-by-age-201822.csv"), 
                 col_types = list('i','i','d','d','d','d'))  %>%
        mutate(across(starts_with("age_"), function(x) x/10))
historical <- read_csv(here("allData", "gp", "ili-by-age-201718.csv"), 
                 col_types = list('i','i','d','d','d','d')) %>%
        mutate(across(starts_with("age_"), function(x) x/100))
ili <- rbind(recent, historical) %>%
        mutate(across(everything(), as.integer))
suppressWarnings(rm(recent, historical))

## swab ------------------------------------------------------------------------
swabs <- read_csv(here("allData", "swab", "2014 - 2021 swab data.csv"),
                  col_types = 'i') %>% 
          as_tibble() %>%
          select(4,5,2,3)

## hosp ------------------------------------------------------------------------
hosp <- here("allData", "weekly_report_flu_2023.xlsx") %>%
        read_xlsx(sheet = 32, range = "B8:H60", col_names = TRUE) %>%
        pivot_longer(cols = c(2:7), names_to = "Season") %>%
        slice(-c(277:312)) %>%
        arrange(Season)

## mortality -------------------------------------------------------------------
 dest <- here("allData", "mortality", "cod22.xlsx")
cod22 <- read.xlsx(dest, sheet = 6, rows = c(6:59)) %>%
          mutate(Year = 2022) %>%
          select(9,1,6)

 dest <- here("allData", "mortality", "cod21.xlsx")
cod21 <- read.xlsx(dest, sheet = 6, rows = c(6,7,11,12,15,16,19,20),  
                   rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
          drop_na()  %>%
          slice(5)  %>%
          t() %>%
          tibble(Year = 2021, Week = 0:52, Due_to = .) %>%
          slice(-1)

 dest <- here("allData", "mortality", "cod20.xlsx")
cod20 <- read.xlsx(dest, sheet = 1, rows = c(7:60), 
                   rowNames = F, colNames = T,
                   skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
          mutate("Week Number" = row_number()) %>%
          select(1,8,4)

dest <- here("allData", "mortality", "historical.xlsx")
prev <- read.xlsx(dest, sheet = 4, rows = c(5:57), rowNames = F, colNames = T,
                        skipEmptyRows = F, skipEmptyCols = F, fillMergedCells = T) %>%
              melt(id.vars = 'Week.number', variable.name = 'Series')  %>%
              select(2,1,3) %>%
              slice(-c(209:312)) %>%
              mutate(across(Series, as.character))

allmort <- mapply(c, cod22, cod21, cod20, prev) %>% 
            as_tibble() %>%
            mutate(across(everything(), as.integer)) %>%
            arrange(Year)

colnames(allmort) <- c("Year", "Week", "Due_to") 
suppressWarnings(rm(cod20, cod21, cod22, prev))

# PRE PROCESSING ###############################################################
# convert to time-series type object
ili_ts <- ili[,4] %>%
          replace(is.na(.), 0) %>%
          ts(frequency = 52, start = c(2016,1))
plot(ili_ts)

swab_ts <- swabs %>%
            mutate(new = flu_A + flu_B, .keep = "none") %>%
            ts(frequency = 52, start = c(2014,23)) 
plot(swab_ts)

hosp_ts <- hosp[,3] %>%
            replace(is.na(.), 0) %>%
            ts(frequency = 52, start = c(2017,40))
plot(hosp_ts)

mort_ts <- allmort[,3] %>%
            ts(frequency = 52, start = c(2016,1))
plot(mort_ts)

df <- data.frame(ili_ts, swab_ts, hosp_ts, mort_ts)
