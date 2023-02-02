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

# CLEANING #####################################################################

swab_cor <- (typeA1 + typeB1) %>% select(-1)
primary_care_cor <- primary_care_total %>% select(-1)
hosp_cor <- hosp_vis %>% select(-1)
mortality_cor <- tibble("17-18" = historical[92:124, 4],
                        "18-19" = historical[144:176, 4],
                        "19-20" = rbind(historical, cod20)[196:228, 4],
                        "22-23" = rbind(cod22, cod23)[40:72, 4])

suppressWarnings({
  rm(primary_care_201718, primary_care_2021, primary_care_2022,
     primary_care_2023, primary_care_vis, recent, historical, primary_care_total)
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
  rm(dest, i, link, nas, path, w)
})

# REAL STUFF ###################################################################

## swab vs gp ------------------------------------------------------------------

# swab_vs_gp <- matrix(nrow = 4, ncol = 8)
# rownames(swab_vs_gp) = c("swab2017", "swab2018", "swab2019", "swab2022")
# colnames(swab_vs_gp) = c("gp_t-2", "gp_t-1", "gp_0", "gp_t+1", "gp_t+2", "gp_t+3", "gp_t+4", "gp_t+5")

## gp vs hosp ------------------------------------------------------------------
{
primary_care_cor[14,4] <- NA
gphosp <- tibble(year = NA, lag = NA, rho = NA, p = NA)
allcor <- tibble(year = NA, lag = NA, rho = NA, p = NA)
years = c(2017, 2018, 2019, 2022)
}
for(j in 1:4) {
  for(i in 0:5) {
    x <- hosp_cor %>% 
          select(j) %>%
          drop_na() %>%
          tail(dim(.)[1]-i) %>%
          pull(1)
    y <- primary_care_cor %>% 
          select(j) %>%
          drop_na() %>%
          mutate(lag(., i)) %>%
          drop_na() %>%
          pull(1)
    c <- cor.test(x, y, method = 'spearman', exact = FALSE)
    allcor %<>% rbind(tibble(year = years[j], lag = i, rho = c$estimate,  p = c$p.value))
}}
allcor %>%
  group_by(year) %>%
  slice(which.max(rho)) -> gp_vs_hosp


