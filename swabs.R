# Szymon Jakobsze
# Flu swab data UKHSA & Datamart

source("source_data_entry.R")
here::i_am("swabs.R")

# Create initial plots
plotA <- ggplot(typeA, aes(id, value)) +
  geom_line(lwd = 1.5, aes(colour = series)) +
  ggtitle("Positive influenza type A test results") +
  theme_ipsum() +
  ylab("Number of cases") +
  scale_x_discrete(name = "Week",
                   limits = c("40", "41", "42", "43", "44",
                              "45", "46", "47", "48", "49",
                              "50", "51", "52", "1", "2", "3",
                              "4", "5", "6", "7", "8", "9", "10",
                              "11", "12", "13", "14", "15", "16",
                              "17", "18", "19", "20")) +
  theme(panel.border = element_rect(color = "dark grey",
                                    fill = NA,
                                    size = 0.1)) +
  scale_color_manual('Season', values= wes_palette("Moonrise1", n = 4))


plotB <- ggplot(typeB, aes(id, value)) +
  geom_line(lwd = 1.5, aes(colour = series)) +
  ggtitle("Positive influenza type B test results") +
  theme_ipsum() +
  ylab("Number of cases") +
  scale_x_discrete(name = "Week",
                   limits = c("40", "41", "42", "43", "44",
                              "45", "46", "47", "48", "49",
                              "50", "51", "52", "1", "2", "3",
                              "4", "5", "6", "7", "8", "9", "10",
                              "11", "12", "13", "14", "15", "16",
                              "17", "18", "19", "20")) +
  theme(panel.border = element_rect(color = "dark grey",
                                    fill = NA,
                                    size = 0.1)) +
  scale_color_manual('Season', values= wes_palette("Moonrise1", n = 4))

combined_plot <- ggarrange(plotA, plotB, 
                           ncol = 1, nrow = 2)

combined_plot
