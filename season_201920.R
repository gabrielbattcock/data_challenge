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


here::i_am("season201920.R")

hospital <- df_list_201920$USISS_Sentinel[4]
gp =  as.numeric(df_list_201920$RCGP$...4[2:34])
swab_df <- swabs %>% slice(279:311)
swab_df$total = swab_df$flu_A+swab_df$flu_B
swab <- swab_df$total
week <- seq(1:33)
season_201920 <- data.frame( week,hospital, gp, swab)
names(season_201920) <- c("week", "hospital", "gp", "swab")


ggplot(season_201920) +
  theme_ipsum() +
  geom_line(aes(week, hospital, color = 'Hospital')) +
  geom_line(aes(week, gp, color = 'GP')) +
  #geom_line(aes(week, swab, color = 'Swabbing data')) +
  guides(color = guide_legend("Data source")) +
  ylab("Influenza cases (cases per 100,000)") +
  # xlim(-12, 20)+
  ggtitle("UK influenza cases 2019-20 per different data sources") +
  scale_x_discrete(name = "Week",
                   limits = c("40", "41", "42", "43", "44",
                              "45", "46", "47", "48", "49",
                              "50", "51", "52", "1", "2", "3",
                              "4", "5", "6", "7", "8", "9", "10",
                              "11", "12", "13", "14", "15", "16",
                              "17", "18", "19", "20"
                   ))+
  theme(panel.border = element_rect(color = "dark grey",
                                    fill = NA,
                                    size = 0.1)) +
  scale_color_manual('Season', values= wes_palette("Moonrise1", n = 2))




#normalising it so all the peaks are the same heigh (swab data is in number not rate)
# hospital_norm <- hospital/mean(hospital), rm.na = T)



