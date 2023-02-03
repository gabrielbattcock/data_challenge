# trial log graph t

### seasonality 2019-20 year

#Reading in 
library(readxl)
library(pacman)
library(dplyr)
library(stringr)
library(scales)
library(ggrepel)
p_load(tidyverse, knitr, RColorBrewer, kableExtra, ggpubr, ggplot2)
library(pacman)
p_load(tidyverse, here, viridis, hrbrthemes, reshape2, ggpubr, wesanderson)



## 2019-20 data

# here::i_am("R_scripts/Season_data/log_graphs.R")

#read in the data in to suitable data frame for 
hospital <- df_list_201920$USISS_Sentinel[3]
gp =  as.numeric(df_list_201920$RCGP$...4[2:34])
swab_df <- swabs %>% slice(279:311)
swab_df$total = swab_df$flu_A+swab_df$flu_B
swab <- (swab_df$total/56000000)*100000
week <- seq(1:33)
season_201920 <- data.frame( week,hospital$`Hospital admission (rate)`, gp, swab)
names(season_201920) <- c("week", "hospital", "gp", "swab")

log_hosp <- log(hospital$`Hospital admission (rate)`)
log_week <- log(week)
log_gp <- log(gp)
log_swab <- log(swab)
log_season <- data.frame(week, log_hosp = log_hosp, log_gp, log_swab)
log_season_subset <- data.frame(week = week[5:12], hosp = log_season$log_hosp[5:12], 
                                gp = log_season$log_gp[5:12], swab = log_season$log_swab[5:12])

#create linear models for when 
lm_hosp <- lm(data = log_season_subset,formula = hosp~week)
hosp_predict <- data.frame(hosp_line = predict(lm_hosp, log_season_subset), week = log_season_subset$week)
lm_gp <- lm(data = log_season_subset,formula = gp~week)
gp_predict <- data.frame(gp_line = predict(lm_gp, log_season_subset), week = log_season_subset$week)
lm_swab <- lm(data = log_season_subset,formula = swab~week)
swab_predict <- data.frame(gp_line = predict(lm_swab, log_season_subset), week = log_season_subset$week)
summary(lm_gp)
summary(lm_hosp)
summary(lm_swab)

#check whether the R_0 rates are similar
R_eff_19_gp <- 1+lm_gp$coefficients[2]
R_eff_19_hosp <- 1+lm_hosp$coefficients[2]
R_eff_19_swab <- 1+lm_swab$coefficients[2]


log_hosp_plot1920 <- ggplot(log_season) +
  theme_ipsum() +
  geom_line(lwd = 1.5, aes(week, log_hosp, color = 'Hospital')) +
  geom_line(lwd = 1.5, aes(week, log_gp, color = 'GP')) +
  geom_line(lwd = 1.5, aes(week, log_swab, color = 'Swab')) +
  geom_line(data = hosp_predict, aes(week, hosp_line)) +
  geom_line(data = gp_predict, aes(week, gp_line)) + 
  geom_line(data = swab_predict, aes(week, gp_line))+
  # guides(color = guide_legend("Data source")) +
  ylab("Log rate") +
  # # xlim(-12, 20)+
  ggtitle("Log tranformed influenza cases 2019-20 \n per different data sources") +
  scale_x_continuous(breaks = seq(0, 34, 2),
                     minor_breaks = seq(0, 34, 1),
                     labels = c("40", "42", "44",
                                "46", "48",
                                "50", "52", "2",
                                "4", "6", "8", "10",
                                "12","14","16",
                                "18", "20", "22")) +
  theme(panel.border = element_rect(color = "dark grey",
                                    fill = NA,
                                    size = 0.1)) +
  coord_cartesian(ylim = c(-4, 4), expand = FALSE) +
  scale_color_manual('Season', values= palette_flu)

log_hosp_plot1920
# geom_smooth(data = log_season_subset, formula = hosp~week, method = 'lm')

#-------------------------------------------------------------------------------

#2018-19 data

hospital18 <- df_list_201819$USISS_Sentinel[4]
gp18 =  as.numeric(df_list_201819$RCGP$...3[2:34])
swab_df <- swab_season18_19
swab_df$total = swab_df$flu_A+swab_df$flu_B
swab18 <- (swab_df$total/56000000)*100000
season_201819 <- data.frame( week,hospital18, gp18, swab18)
names(season_201819) <- c("week", "hospital", "gp", "swab")


log_hosp <- log(hospital18$`2018-19 Hospital admission (rate)`)
log_week <- log(week)
log_gp <- log(gp18)
log_swab <- log(swab18)
log_season <- data.frame(week, log_hosp = log_hosp, log_gp, log_swab)
log_season_subset <- data.frame(week = week[7:17], hosp = log_season$log_hosp[7:17], 
                                gp = log_season$log_gp[7:17], swab = log_season$log_swab[7:17])

#create linear models for when 
lm_hosp <- lm(data = log_season_subset,formula = hosp~week)
hosp_predict <- data.frame(hosp_line = predict(lm_hosp, log_season_subset), week = log_season_subset$week)
lm_gp <- lm(data = log_season_subset,formula = gp~week)
gp_predict <- data.frame(gp_line = predict(lm_gp, log_season_subset), week = log_season_subset$week)
lm_swab <- lm(data = log_season_subset,formula = swab~week)
swab_predict <- data.frame(gp_line = predict(lm_swab, log_season_subset), week = log_season_subset$week)
summary(lm_gp)
summary(lm_hosp)
summary(lm_swab)




# calculate R effective for each of the data sources  

R_eff_18_gp <- 1+lm_gp$coefficients[2]
R_eff_18_hosp <- 1+lm_hosp$coefficients[2]
R_eff_18_swab <- 1+lm_swab$coefficients[2]


#check whether the R_0 rates are similar



log_hosp_plot1819 <- ggplot(log_season) +
  theme_ipsum() +
  geom_line(lwd = 1.5, alpha = 0.6,aes(week, log_hosp, color = 'Hospital')) +
  geom_line(lwd = 1.5, alpha = 0.6,aes(week, log_gp, color = 'GP')) +
  geom_line(lwd = 1.5, alpha = 0.6,aes(week, log_swab, color = 'Swab')) +
  geom_line(data = hosp_predict, aes(week, hosp_line)) +
  geom_line(data = gp_predict, aes(week, gp_line)) + 
  geom_line(data = swab_predict, aes(week, gp_line))+
  # guides(color = guide_legend("Data source")) +
  ylab("Log rate") +
  # # xlim(-12, 20)+
  ggtitle("Log tranformed influenza cases 2018-19 \n per different data sources") +
  scale_x_continuous(breaks = seq(0, 34, 2),
                     minor_breaks = seq(0, 34, 1),
                     labels = c("40", "42", "44",
                                "46", "48",
                                "50", "52", "2",
                                "4", "6", "8", "10",
                                "12","14","16",
                                "18", "20", "22")) +
  theme(panel.border = element_rect(color = "dark grey",
                                    fill = NA,
                                    size = 0.1)) +
  coord_cartesian(ylim = c(-4, 4), expand = FALSE) +
  scale_color_manual('Season', values= palette_flu)

log_hosp_plot1819
#-------------------------------------------------------------------------------
#2017-18 data

hospital17 <- data_2017$sent_rate
gp17 =  as.numeric(primary_care_201718$`GP ILI consulation rates (all ages)`[2:34])
swab_df <- swab_season17_18
swab_df$total = swab_df$flu_A+swab_df$flu_B
swab17 <- (swab_df$total/56000000)*100000
week <- seq(1:33)
season_201718 <- data.frame( week,hospital17, gp17, swab17)
names(season_201718) <- c("week", "hospital", "gp", "swab")


log_hosp <- log(hospital17)
log_week <- log(week)
log_gp <- log(gp17)
log_swab <- log(swab17)
log_season <- data.frame(week, log_hosp = log_hosp, log_gp, log_swab)
log_season_subset <- data.frame(week = week[7:15], hosp = log_season$log_hosp[7:15], 
                                gp = log_season$log_gp[7:15], swab = log_season$log_swab[7:15])

#create linear models for when 
lm_hosp <- lm(data = log_season_subset,formula = hosp~week)
hosp_predict <- data.frame(hosp_line = predict(lm_hosp, log_season_subset), week = log_season_subset$week)
lm_gp <- lm(data = log_season_subset,formula = gp~week)
gp_predict <- data.frame(gp_line = predict(lm_gp, log_season_subset), week = log_season_subset$week)
lm_swab <- lm(data = log_season_subset,formula = swab~week)
swab_predict <- data.frame(gp_line = predict(lm_swab, log_season_subset), week = log_season_subset$week)
summary(lm_gp)
summary(lm_hosp)
summary(lm_swab)

#check whether the R_0 rates are similar

R_eff_17_gp <- 1+lm_gp$coefficients[2]
R_eff_17_hosp <- 1+lm_hosp$coefficients[2]
R_eff_17_swab <- 1+lm_swab$coefficients[2]


log_hosp_plot1718 <- ggplot(log_season) +
  theme_ipsum() +
  geom_line(lwd = 1.5, alpha = 0.6,aes(week, log_hosp, color = 'Hospital')) +
  geom_line(lwd = 1.5, alpha = 0.6,aes(week, log_gp, color = 'GP')) +
  geom_line(lwd = 1.5, alpha = 0.6,aes(week, log_swab, color = 'Swab')) +
  geom_line(data = hosp_predict, aes(week, hosp_line)) +
  geom_line(data = gp_predict, aes(week, gp_line)) + 
  geom_line(data = swab_predict, aes(week, gp_line))+
  # guides(color = guide_legend("Data source")) +
  ylab("Log rate") +
  # # xlim(-12, 20)+
  ggtitle("Log tranformed influenza cases 2017-18 \n per different data sources") +
  scale_x_continuous(breaks = seq(0, 34, 2),
                     minor_breaks = seq(0, 34, 1),
                     labels = c("40", "42", "44",
                                "46", "48",
                                "50", "52", "2",
                                "4", "6", "8", "10",
                                "12","14","16",
                                "18", "20", "22")) +
  theme(panel.border = element_rect(color = "dark grey",
                                    fill = NA,
                                    size = 0.1)) +
  coord_cartesian(ylim = c(-4, 5), expand = FALSE) +
  scale_color_manual('Season', values= palette_flu)

log_hosp_plot1718

#-------------------------------------------------------------------------------
#season 2022-23


hospital22 <- hosp_vis[5]$`2022-23`
gp22 =  primary_care_total$`2022-23`
swab_df <- swab_season22_23
swab_df$total = swab_df$flu_A+swab_df$flu_B
swab22 <- (swab_df$total/56000000)*100000
season_202223 <- data.frame( week,hospital22, gp22, swab22)
names(season_202223) <- c("week", "hospital", "gp", "swab")

#log transform
log_hosp <- log(hospital22)
log_week <- log(week)
log_gp <- log(gp22)
log_swab <- log(swab22)
log_season <- data.frame(week, log_hosp, log_gp, log_swab)
log_season_subset <- data.frame(week = week[5:12], hosp = log_hosp[5:12],
                                gp = log_season$log_gp[3:10], swab = log_season$log_swab[5:12])

#create linear models for when
lm_hosp <- lm(data = log_season_subset,formula = hosp~week)
hosp_predict <- data.frame(hosp_line = predict(lm_hosp, log_season_subset), week = log_season_subset$week)
lm_gp <- lm(data = log_season_subset,formula = gp~week)
gp_predict <- data.frame(gp_line = predict(lm_gp, log_season_subset), week = log_season_subset$week)
lm_swab <- lm(data = log_season_subset,formula = swab~week)
swab_predict <- data.frame(gp_line = predict(lm_swab, log_season_subset), week = log_season_subset$week)
summary(lm_gp)
summary(lm_hosp)
summary(lm_swab)

#check whether the R_0 rates are similar
R_eff_22_gp <- 1+lm_gp$coefficients[2]
R_eff_22_hosp <- 1+lm_hosp$coefficients[2]
R_eff_22_swab <- 1+lm_swab$coefficients[2]


log_hosp_plot2223 <- ggplot(log_season) +
  theme_ipsum() +
  geom_line(lwd = 1.5, alpha = 0.6, aes(week, log_hosp, color = 'Hospital')) +
  geom_line(lwd = 1.5, alpha = 0.6, aes(week, log_gp, color = 'GP')) +
  geom_line(lwd = 1.5, alpha = 0.6, aes(week, log_swab, color = 'Swab')) +
  geom_line(data = hosp_predict, aes(week, hosp_line)) +
  geom_line(data = gp_predict, aes(3:10, gp_line)) +
  geom_line(data = swab_predict, aes(week, gp_line))+
  # guides(color = guide_legend("Data source")) +
  ylab("Log rate") +
  # # xlim(-12, 20)+
  ggtitle("Log tranformed influenza cases 2022-23 \n per different data sources") +
  scale_x_continuous(breaks = seq(0, 34, 2),
                     minor_breaks = seq(0, 34, 1),
                     labels = c("40", "42", "44",
                                "46", "48",
                                "50", "52", "2",
                                "4", "6", "8", "10",
                                "12","14","16",
                                "18", "20", "22")) +
  theme(panel.border = element_rect(color = "dark grey",
                                    fill = NA,
                                    size = 0.1)) +
  coord_cartesian(ylim = c(-4, 4), expand = FALSE) +
  scale_color_manual('Season', values= palette_flu)

log_hosp_plot2223
# 
# #--------------------------------------------------------------------------------
log_table_tibble <- tibble(
  index_log_dat = c("2017-18","2018-19","2019-20", "2022-23"),
  gp_log_dat = round(c(R_eff_17_gp, R_eff_18_gp, R_eff_19_gp, R_eff_22_gp), digits=1),
  hosp_log_dat = round(c(R_eff_17_hosp, R_eff_18_hosp, R_eff_19_hosp, R_eff_22_hosp), digits = 1),
  swabs_log_dat = round(c(R_eff_17_swab, R_eff_18_swab, R_eff_19_swab, R_eff_22_swab), digits = 1)
)




effective_r_values <- log_table_tibble %>% gt() %>% tab_header(
  title = "Effective R values",
  subtitle = "Across flu seasons between 2017-18 and 2022-23"
)  %>%
  tab_source_note(
    source_note = "Note: Data removed for 2021-22 flu season due to effect of Covid-19 pandemic on flu cases"
  )%>%
  tab_spanner(
    label = md("**Sources of flu data**"),
    columns = c(gp_log_dat, hosp_log_dat, swabs_log_dat)
  ) %>%
  cols_label(
    index_log_dat = md("**Flu season**"),
    gp_log_dat = md("**Primary care**"),
    hosp_log_dat = md("**Secondary care**"),
    swabs_log_dat = md("**Lab confirmed cases**")
  ) %>% gt_theme_538()


