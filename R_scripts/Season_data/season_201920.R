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

# here::i_am("R_scripts/Season/season_201920.R")

hospital <- df_list_201920$USISS_Sentinel[3]
gp =  as.numeric(df_list_201920$RCGP$...4[2:34])
swab_df <- swabs %>% slice(279:311)
swab_df$total = swab_df$flu_A+swab_df$flu_B
swab <- (swab_df$total/56000000)*100000
week <- seq(1:33)
season_201920 <- data.frame( week,hospital, gp, swab)
names(season_201920) <- c("week", "hospital", "gp", "swab")

# Add some of the missing data from season 2019-2020
# season_201920[23:33,3] <- (as.double(age1920$age_all[23:33]))/10


plot_201920 <- ggplot(season_201920) +
  theme_ipsum() +
  geom_line(lwd = 1.5, alpha = 0.6, aes(week, hospital, color = 'Hospital')) +
  geom_line(lwd = 1.5, alpha = 0.6, aes(week, gp, color = 'GP')) +
  geom_line(lwd = 1.5, alpha = 0.6, aes(week, swab, color = 'Swabbing data')) +
  guides(color = guide_legend("Data source")) +
  ylab("Influenza rate (per 100,000)") +
  # xlim(-12, 20)+
  ggtitle("2019-20") +
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
  coord_cartesian(ylim = c(-1, 25), expand = FALSE) +
  scale_color_manual('Season', values= palette_flu)

plot_201920
#normalising it so all the peaks are the same heigh (swab data is in number not rate)
# hospital_norm <- hospital/mean(hospital), rm.na = T)



