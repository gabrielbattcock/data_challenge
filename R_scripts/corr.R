# NOTES ########################################################################

# This script attempt to repeat spearman's rho tests of correlation
# pairwise for every combination of two data sources, for every year. 

# The tests will be run four times each pair, at a lag of 0 - 3 data points (weeks)
# the best correlation will be reported with its corresponding lag value.

# INIT #########################################################################

library(pacman)
p_load(tidyverse, magrittr, here, lmtest)
here::i_am("R_scripts/corr.r")
suppressMessages(source(here("R_scripts", "source_data_entry.R")))

if(!file.exists('/System/Volumes/Data/Applications/Google Chrome.app')) {
  print("WARNING: gtsave() needs a chromium-based browser to work.")
  browser <- readline("Enter the name of a chromium-based browser installed on your machine: ")  
  Sys.setenv(CHROMOTE_CHROME = paste0("/Applications/",browser, ".app/Contents/MacOS/", browser))
}  

# CLEANING #####################################################################

swab_cor <- (typeA1 + typeB1) %>% select(-1)
# primary_care_cor <- primary_care_total %>% select(-1)
hosp_cor <- hosp_vis %>% select(-1)
mort_cor <- tibble("17-18" = historical[92:124, 4],
                    "18-19" = historical[144:176, 4],
                    "19-20" = rbind(historical, cod20)[196:228, 4],
                    "22-23" = rbind(cod22, cod23)[40:72, 4])
gp_cor <- tibble("17-18"  = ili[1:33, 6],
                  "18-19" = ili[34:66, 6],
                  "19-20" = ili[86:118, 6],
                  "22-23" = rbind(ili[243:254, 6], tibble("age_all" = NA, .rows = 21)))
years = c(2017, 2018, 2019, 2022)

suppressWarnings({
  rm(primary_care_201718, primary_care_2021, primary_care_2022, primary_care_2023, 
     primary_care_vis, recent, historical, primary_care_total)
  rm(swab_season17_18, swab_season18_19, swab_season19_20,
    swab_season22_23, swabs, swab_vis, typeA, typeB, typeA1, typeB1)
  rm(data_2017, week, hosp_17_18, hosp_18_19, hosp_19_20, hosp_22_23,
     sheet_vector_201819, sheet_vector_201920, sheet_vector_2021,
     sheet_vector_2022, sheet_vector_2023, hosp_vis)
  rm(df_list_201819, df_list_201920, df_list_2021,
     df_list_2022, df_list_2023, supplement_data_2023,
     cod20, cod21, cod22, cod23, historical, mortality_vis_list, mortality_vis, allmort)
  rm(vac17, vac17_1, vac17_2, vac17_3, vac17_4, vac18, vac19, 
     vac20, vac21, vac22, vac_label, vacc_rate, vaccine_vis)
  rm(age_strat_df1, age_strat_df2)
  rm(c, dest, i, link, nas, path, w, gt_theme_538)
})

# REAL STUFF ###################################################################

# Using cor.test betw x and y, method = 'spearman'.   
# x is static. y is dynamic. logically we expect y to peak earlier than x,
# so that when you push y with a certain lag, x~y correlation increases.

## swab=y=earlier, gpili=x=later -----------------------------------------------
swab_now <- swab_cor
swab_now[13:14,4] <- NA
allcor <- tibble(year = NA, lag = NA, rho = NA, p = NA)
for(j in 1:4) {
  for(i in 0:5) {
    x <- gp_cor %>% 
          select(as.integer(j)) %>%
          drop_na() %>%
          tail(dim(.)[1]-i) %>%
          pull(1) %>%
          as_vector()
    y <- swab_now %>% 
          select(as.integer(j)) %>%
          drop_na() %>%
          mutate(lag(., i)) %>%
          drop_na() %>%
          pull(1)
    c <- cor.test(x, y, method = 'spearman', exact = FALSE)
    allcor %<>% rbind(tibble(year = years[j], lag = i, rho = round(c$estimate,3),  p = c$p.value))
  }}

allcor$p <- "***"
vs_swab_gp <- allcor %>%
              group_by(year) %>%
              slice(which.max(rho)) %>%
              ungroup() %>%
              gt() %>%
              tab_header(title = "GP data with reference to Swab data") %>%
              gtsave(here("report", "images", "vs-swab-gp.png"))

## gpili=y=earlier, hosp=x=later -----------------------------------------------
allcor <- tibble(year = NA, lag = NA, rho = NA, p = NA)
gp_now <- gp_cor
gp_now[23:33, 3] <- NA
hosp_now <- hosp_cor
hosp_now[13, 4] <- NA

for(j in 1:4) {
  for(i in 0:5) {
    x <- hosp_now %>% 
          select(as.integer(j)) %>%
          drop_na() %>%
          tail(dim(.)[1]-i) %>%
          pull(1) %>%
          as_vector()
    y <- gp_now %>% 
          select(as.integer(j)) %>%
          drop_na() %>%
          mutate(lag(., i)) %>%
          drop_na() %>%
          pull(1) %>%
          as_vector()
    c <- cor.test(x, y, method = 'spearman', exact = FALSE)
    allcor %<>% rbind(tibble(year = years[j], lag = i, rho = round(c$estimate,3),  p = c$p.value))
  }}

allcor$p <- "***"
vs_gp_hosp <- allcor %>%
              group_by(year) %>%
              slice(which.max(rho)) %>%
              ungroup() %>%
              gt() %>%
              tab_header(title = "Hospitalisation with reference to GP data") %>%
              gtsave(here("report", "images", "vs-gp-hosp.png"))

## hosp=y=earlier, mortality=x=later -------------------------------------------
allcor <- tibble(year = NA, lag = NA, rho = NA, p = NA)
mort_now <- mort_cor
mort_now[23:33, 3] <- NA

for(j in 1:3) {
  for(i in 0:5) {
    x <- mort_now %>% 
          select(as.integer(j)) %>%
          drop_na() %>%
          tail(dim(.)[1]-i) %>%
          pull(1) %>%
          as_vector()
    y <- hosp_now %>% 
          select(as.integer(j)) %>%
          drop_na() %>%
          mutate(lag(., i)) %>%
          drop_na() %>%
          pull(1) %>%
          as_vector()
    c <- cor.test(x, y, method = 'spearman', exact = FALSE)
    allcor %<>% rbind(tibble(year = years[j], lag = i, rho = round(c$estimate,3),  p = c$p.value))
}}

allcor$p <- "***"
vs_hosp_mort <- allcor %>%
                group_by(year) %>%
                slice(which.max(rho)) %>%
                ungroup() %>%
                gt() %>%
                tab_header(title = "Mortality with reference to Hospitalisation") %>%
                gtsave(here("report", "images", "vs-hosp-mort.png"))

## two way loop ----------------------------------------------------------------
## working, but not in use.
## hosp=y=earlier, mortality=x=later
# allcor <- tibble(year = NA, lag = NA, rho = NA, p = NA)
# mort_now <- mort_cor
# mort_now[23:33, 3] <- NA
# 
# for(j in 1:3) {
#   for(i in 0:5) {
#     x <- mort_now %>%
#           select(as.integer(j)) %>%
#           drop_na() %>%
#           tail(dim(.)[1]-i) %>%
#           pull(1) %>%
#           as_vector()
#     y <- hosp_now %>%
#           select(as.integer(j)) %>%
#           drop_na() %>%
#           mutate(lag(., i)) %>%
#           drop_na() %>%
#           pull(1) %>%
#           as_vector()
#     c <- cor.test(x, y, method = 'spearman', exact = FALSE)
#     allcor %<>% rbind(tibble(year = years[j], lag = i, rho = round(c$estimate,3),  p = round(c$p.value,2)))
# }}
# 
# allcor$p <- "***"
# vs_mort_hosp <- allcor %>%
#                 group_by(year) %>%
#                 slice(which.max(rho)) %>%
#                 ungroup() %>%
#                 gt() %>%
#                 tab_header(title = "GP data with reference to Swab data")
# print("Every year, hosp peaks first, after k weeks, mortality peaks")
# print(test)

