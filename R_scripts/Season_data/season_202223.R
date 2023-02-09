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


## 2022-23 data

# here::i_am("R_scripts/Season/season_202223.R")

# hospital <- hosp_vis$hosp_22_23
# gp =  primary_care_total$`2022-23`
# swab_df <- swab_season22_23
# swab_df$total = swab_df$flu_A+swab_df$flu_B
# swab <- (swab_df$total/56000000)*100000
# week <- seq(1:33)
# season_202223 <- data.frame(week, hospital, gp, swab)


hospital22 <- hosp_vis[5]
gp22 =  primary_care_total$`2022-23`
swab_df <- swab_season22_23
swab_df$total = swab_df$flu_A+swab_df$flu_B
swab22 <- (swab_df$total/56000000)*100000
season_202223 <- data.frame( week,hospital22, gp22, swab22)
names(season_202223) <- c("week", "hospital", "gp", "swab")


plot_202223 <- ggplot(season_202223) +
  theme_ipsum() +
  geom_line(lwd = 1.5, alpha = 0.6,aes(x = week, y = hospital, color = 'Hospital')) +
  geom_line(lwd = 1.5, alpha = 0.6,aes(x = week, y = gp, color = 'GP')) +
  geom_line(lwd = 1.5, alpha = 0.6,aes(x = week, y = swab, color = 'Swabbing data')) +
  guides(color = guide_legend("Data source")) +
  ylab("Influenza cases (cases per 100,000)") +
  # xlim(-12, 20)+
  ggtitle("2022-23") +
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
                                    size = 0.1),
        legend.text = element_text(size = 18),
        legend.title = element_text(size = 18),
        # axis.title = element_text(size=20),
        axis.text=element_text(size=20),
        axis.ticks.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank() )+
  scale_color_manual('Season', values= palette_flu)

plot_202223
#normalising it so all the peaks are the same heigh (swab data is in number not rate)
# hospital_norm <- hospital/mean(hospital), rm.na = T)


combined_seasonal_plot <- ggarrange(plot_201718,plot_201819,plot_201920,plot_202223,
                                    ncol = 2, nrow = 2,
                                    common.legend = TRUE, legend="bottom")
