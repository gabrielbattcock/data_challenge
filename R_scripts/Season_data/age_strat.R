### looking at influnza like illness by age


library(readxl)
library(pacman)
library(dplyr)
library(stringr)
library(scales)
library(ggrepel)
p_load(tidyverse, knitr, RColorBrewer, kableExtra, ggpubr, ggplot2)
library(pacman)
p_load(tidyverse, here, viridis, hrbrthemes, reshape2, ggpubr, wesanderson)


df1 <- read_csv("allData/gp/ili-by-age-201718.csv")
df2 <- read_csv("allData/gp/ili-by-age-201822.csv")

df1$age_15 <- df1$age_15/100
df1$age_adult <- df1$age_adult/100
df1$age_65 <- df1$age_65/100
df1$age_all <- df1$age_all/100
df3 <- rbind(df1,df2)

df2$age_15 <- as.numeric(df2$age_15)/5
df2$age_adult <- as.numeric(df2$age_adult)/5
df2$age_65 <- as.numeric(df2$age_65)/5
df2$age_all <- as.numeric(df2$age_all)/5

names(df1)
#------------------------------------------------------------------------------
# very interesting plot for 17-18 by age (altohugh total doesnt make sense)
age1718 <- ggplot(df1) +
  theme_ipsum() +
  geom_line(lwd = 1.5, aes(1:33, age_15, color = 'Under 18s')) +
  geom_line(lwd = 1.5, aes(1:33, age_adult, color = '18-65')) +
  geom_line(lwd = 1.5, aes(1:33, age_65, color = '65 and older')) +
  geom_line(lwd = 1.5, aes(1:33, age_all, color = 'All ages')) +
  guides(color = guide_legend("Age")) +
  ylab("Influenza rate (per 100,000) ") +
  # xlim(-12, 20)+
  ggtitle("UK influenza cases 2017-18 /n per age group") +
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
  coord_cartesian(ylim = c(-1, 70), expand = FALSE) +
  scale_color_manual('Season', values= wes_palette("Moonrise1", n = 4))

#------------------------------------------------------------------------------
#this one doesn't make as much sense

age1822 <- ggplot(df2) +
  theme_ipsum() +
  geom_line(lwd = 1.5, aes(1:221, age_15, color = 'Under 18s')) +
  geom_line(lwd = 1.5, aes(1:221, age_adult, color = '18-65')) +
  geom_line(lwd = 1.5, aes(1:221, age_65, color = '65 and older')) +
  geom_line(lwd = 1.5, aes(1:221, age_all, color = 'All ages')) +
  guides(color = guide_legend("Age")) +
  ylab("Influenza rate (per 100,000) ") +
  xlim(33+52*3, 33+52*4)+
  ggtitle("UK influenza cases 2017-18 /n per age group") +
  # scale_x_continuous(breaks = seq(0, 34, 2), 
  #                    minor_breaks = seq(0, 34, 1),
  #                    labels = c("40", "42", "44",
  #                               "46", "48",
  #                               "50", "52", "2",
  #                               "4", "6", "8", "10",
  #                               "12","14","16",
  #                               "18", "20", "22")) + 
  theme(panel.border = element_rect(color = "dark grey",
                                    fill = NA,
                                    size = 0.1)) +
  coord_cartesian(ylim = c(-1, 60), expand = FALSE) +
  scale_color_manual('Season', values= wes_palette("Moonrise1", n = 4))

