
library(pacman)
p_load(tidyverse, knitr, kableExtra, mada, magrittr, 
       RcppRoll, reshape2, spgwr)                           # data manipulation
p_load(curl, here, openxlsx, readODS, readxl)               # reading files
p_load(ggrepel, ggpubr, gt, gtsummary, hrbrthemes, 
       RColorBrewer, robvis, scales, wesanderson)     


#Generating the max rates table for our three data sources
max_table_tibble <- tibble(
  seasons_table = c(
    "2017-18",
    "2018-19",
    "2019-20",
    "2022-23"
  ),
  max_gp = round(c(
    max(season_201718$gp),
    max(season_201819$gp),
    max(season_201920$gp, na.rm=TRUE),
    max(season_202223$gp, na.rm=TRUE)
  ), digit=2),
  max_hosp = round(c(
    max(season_201718$hospital),
    max(season_201819$hospital),
    max(season_201920$hospital, na.rm=TRUE),
    max(season_202223$hospital, na.rm=TRUE)
  ), digit=2),
  
  max_swabs = round(c(
    max(season_201718$swab),
    max(season_201819$swab),
    max(season_201920$swab, na.rm=TRUE),
    max(season_202223$swab, na.rm=TRUE)
  ), digit=2)
)
max_table <- max_table_tibble %>% gt() %>% tab_header(
  title = "Peak cases across included flu seasons",
  subtitle = "Cases per 100,000"
) %>%  
  tab_spanner(
    label = md("**Sources of flu data**"),
    columns = c(max_gp, max_hosp, max_swabs)
  ) %>%
  cols_label(
    seasons_table = md("**Flu season**"),
    max_gp = md("Primary care"),
    max_hosp = md("Secondary care"),
    max_swabs = md("Lab confirmed cases")
  ) %>%
  
  gt_theme_538()