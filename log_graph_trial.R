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

here::i_am("season_201920.R")

#read in the data in to suitable data frame for 
hospital <- df_list_201920$USISS_Sentinel[3]
gp =  as.numeric(df_list_201920$RCGP$...4[2:34])
swab_df <- swabs %>% slice(279:311)
swab_df$total = swab_df$flu_A+swab_df$flu_B
swab <- (swab_df$total/56000000)*100000
week <- seq(1:33)
season_201920 <- data.frame( week,hospital$`2018-19 Hospital admission (rate)`, gp, swab)
names(season_201920) <- c("week", "hospital", "gp", "swab")

log_hosp <- log10(hospital$`2018-19 Hospital admission (rate)`)
log_week <- log10(week)
log_gp <- log10(gp)
log_swab <- log10(swab)
log_season <- data.frame(week, log_hosp = log_hosp, log_gp, log_swab)
log_season_subset <- data.frame(week = week[5:12], hosp = log_season$log_hosp[5:12], 
                                gp = log_season$log_gp[5:12], swab = log_season$log_swab[5:12])

#creat linear models for when 
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
confint(lm_gp, level = 0.95)

10**0.08166553
10**(0.102)
10**(0.148)


log_hosp_plot <- ggplot(log_season) +
  theme_ipsum() +
  geom_line(lwd = 1.5, aes(week, log_hosp, color = 'Hospital')) +
  geom_line(lwd = 1.5, aes(week, log_gp, color = 'GP')) +
  geom_line(lwd = 1.5, aes(week, log_swab, color = 'Swab')) +
  geom_line(data = hosp_predict, aes(week, hosp_line)) +
  geom_line(data = gp_predict, aes(week, gp_line)) + 
  #geom_line(data = swab_predict, aes(gp_line, week))+
  # guides(color = guide_legend("Data source")) +
  # ylab("Log rate") +
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
  coord_cartesian(ylim = c(-1, 25), expand = FALSE) +
  scale_color_manual('Season', values= wes_palette("Moonrise1", n = 3))

log_hosp_plot 
  # geom_smooth(data = log_season_subset, formula = hosp~week, method = 'lm')
#normalising it so all the peaks are the same heigh (swab data is in number not rate)
# hospital_norm <- hospital/mean(hospital), rm.na = T)



