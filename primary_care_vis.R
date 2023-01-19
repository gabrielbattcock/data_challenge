#Data exploration
library(pacman)
library(dplyr)
library(robvis)
library(stringr)
library(gt)
library(gtsummary)
library(scales)
library(ggrepel)
library(mada)
library(hrbrthemes)
p_load(tidyverse, knitr, RColorBrewer, kableExtra, ggpubr, ggplot2)
#Some data management to create the flu seasons
primary_care_201718 <- read_csv("allData/gp/2017_2018/gp_consultations_17_18.csv")
primary_care_2021 <- df_list_2021$`Figure 33&34. Primary care`$`ILI rate`[2:53]
primary_care_2022 <- df_list_2022$`Figure_31&32__Primary_care`$`ILI rate`
#This is the tibble we're using
primary_care_total <- tibble(
  Weeks = c(40:52, 1:20),
  `2017-18` = as.numeric(primary_care_201718$`GP ILI consulation rates (all ages)`[2:34]),
  `2018-19` = as.numeric(df_list_201819$RCGP$...3[2:34]),
  `2019-20` = as.numeric(df_list_201920$RCGP$...4[2:34]),
  `2021-22` = c(primary_care_2021[40:52], primary_care_2022[1:20])
)

#So doing some more tidyverse tidying. Pivoting longer to avoid using multiple lines
primary_care_vis <- primary_care_total %>% pivot_longer(cols = 2:5, names_to = "Flu Season", values_to = "Rate") %>%
  #Gabriels pattented rearranging code pt.1
  mutate(Weeks = ifelse(Weeks>=40, Weeks-39, Weeks+13)) %>%
  #The GGPLOT stuff
  ggplot() + aes(x=Weeks, y=Rate, colour=`Flu Season`) + 
  #The ribbons are the ranges from below
#https://www.gov.uk/guidance/sources-of-uk-flu-data-influenza-surveillance-in-the-uk#clinical-surveillance-through-primary-care
  geom_ribbon(aes(ymin=0,ymax=12.7),fill="#B7CE89", alpha=0.08)+
  geom_ribbon(aes(ymin=12.7,ymax=24.1),fill="#FEFF67", alpha=0.08)+
  geom_ribbon(aes(ymin=24.1,ymax=60), outline.type="lower",fill="#F7B27E", alpha=0.08)+
  geom_line() + theme_minimal() +
  #My own custom scale, replace with wes please Szymon
   scale_color_manual(values=c( "#2F4F4F","#528B8B","#79CDCD","#8DEEEE")) +
  #Previous colour scheme values=c("#8DEEEE","#79CDCD","#528B8B", "#2F4F4F")
  scale_x_discrete(name = "Week",
                   limits = c("40", "41", "42", "43", "44",
                              "45", "46", "47", "48", "49",
                              "50", "51", "52", "1", "2", "3",
                              "4", "5", "6", "7", "8", "9", "10",
                              "11", "12", "13", "14", "15", "16",
                              "17", "18", "19", "20"
                   )) +
  #Labels
  labs(
    title="GP consultations for Influenza type illness per 100,000",
    subtitle="As collected by the RCGP in England",
    y="Rate of consultations (per 100,000)"
  ) +
  #Some stolen code
  theme( # Adjustments for aesthetic improvements and formatting
    plot.title = element_text(
      hjust = 0.5,
      size = 12,
      face = "bold",
      margin = margin(
        t = 5,
        r = 0,
        b = 3,
        l = 0
      )
    ),
    plot.subtitle = element_text(
      hjust=0.5
    ),
    legend.position = "right",
    legend.key = element_rect(color = NA),
    legend.title.align = 0.5,
    axis.title.x = element_text(
      margin = margin(t=8, r=0, b=0, l=0)),
    axis.text.x = element_text(
      angle = 90,
      vjust = 0.5,
      hjust = 1
    )) 

#Primary care vis (Szymon's version)


ggplot(primary_care_vis, aes(x = Weeks, y = Rate) ) +
  geom_line(lwd = 1.5, aes(colour = `Flu Season`)) +
  labs(x="Week", y="Rate of consultations (per 100,000)",
       title="GP consultations for Influenza type illness per 100,000",
       caption="As collected by the RCGP in England") +
  theme_ipsum() +
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
  geom_ribbon(aes(ymin=0,ymax=12.7),fill="#B7CE89", alpha=0.25)+
  geom_ribbon(aes(ymin=12.7,ymax=24.1),fill="#FEFF67", alpha=0.25)+
  geom_ribbon(aes(ymin=24.1,ymax=60), outline.type="lower",fill="#F7B27E", alpha=0.25)+
  scale_color_manual('Season', values= wes_palette("Moonrise1", n = 4)) +
  coord_cartesian(ylim = c(0, 60), expand = FALSE) +
  scale_y_continuous(breaks = seq(0, 60, 10), 
                     minor_breaks = seq(0, 60, 5)) 
