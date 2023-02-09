### Gabriel Battcock

### looking at influnza like illness by age

# source("R_scripts/source_data_entry.R") #used to get all data frames 

#------------------------------------------------------------------------------
# configuring data into correct frames
#Once this has been run once, this section should be commented out or you should run source_data_entry.R again
# as it will not allow you to reallocate the names once more.
age2223 <- age2223 %>% select(Week,
                              "<15 years" = age_15,
                              "15-64 years" = age_adult,
                              "65+ years" = age_65,
                              "All ages" = age_all) %>%
  melt(id.vars ='Week', variable.name = 'series')

age1920 <- age1920 %>% select(Week,
                              "<15 years" = age_15,
                              "15-64 years" = age_adult,
                              "65+ years" = age_65,
                              "All ages" = age_all) %>%  
  melt(id.vars ='Week', variable.name = 'series')

age1819 <- age1819 %>% select(Week,
                              "<15 years" = age_15,
                              "15-64 years" = age_adult,
                              "65+ years" = age_65,
                              "All ages" = age_all) %>%
  melt(id.vars ='Week', variable.name = 'series') 

age1718 <- age1718 %>% select(Week,
                              "<15 years" = age_15,
                              "15-64 years" = age_adult,
                              "65+ years" = age_65,
                              "All ages" = age_all) %>%
  melt(id.vars ='Week', variable.name = 'series') 

#------------------------------------------------------------------------------
## 2017-18
plot_age1718 <- ggplot(age1718, aes(Week, value)) +
  theme_ipsum() +
  geom_line(lwd = 1.5 , alpha = 0.9, aes(color = series)) +
  ylab("Influenza rate (per 100,000) ") +
  # xlim(33+52*3, 33+52*4)+
  ggtitle("2017-18") +
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
  scale_color_manual("Age", values= palette_flu)


#------------------------------------------------------------------------------
## 2018-19
plot_age1819 <- ggplot(age1819, aes(Week, value)) +
  theme_ipsum() +
  geom_line(lwd = 1.5 , alpha = 0.9, aes(color = series)) +
  ylab("Influenza rate (per 100,000) ") +
  # xlim(33+52*3, 33+52*4)+
  ggtitle("2018-19") +
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
  coord_cartesian(ylim = c(-1, 30), expand = FALSE) +
  scale_color_manual("Age", values= palette_flu)
#------------------------------------------------------------------------------

plot_age1920 <- ggplot(age1920, aes(Week, value)) +
  theme_ipsum() +
  geom_line(lwd = 1.5 , alpha = 0.9, aes(color = series)) +
  ylab("Influenza rate (per 100,000) ") +
  # xlim(33+52*3, 33+52*4)+
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
                                    size = 0.1)) +
  coord_cartesian(ylim = c(-1, 30), expand = FALSE) +
  scale_color_manual("Age", values= palette_flu)

#------------------------------------------------------------------------------
## 2022-23
plot_age2223 <- ggplot(age2223, aes(Week, value)) +
  theme_ipsum() +
  geom_line(lwd = 1.5 , alpha = 0.9, aes(color = series)) +
  ylab("Influenza rate (per 100,000) ") +
  # xlim(0, 33)+
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
                                    size = 0.1)) +
  coord_cartesian(ylim = c(-1, 40), expand = FALSE) +
  scale_color_manual("Age", values= palette_flu)

combined_age_plot <- ggarrange(plot_age1718, plot_age1819,
                               plot_age1920, plot_age2223,
                               ncol = 2, nrow = 2, 
                               common.legend = TRUE, legend="bottom")

combined_age_plot





