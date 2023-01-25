# Szymon Jakobsze
# Flu swab data UKHSA & Datamart

source("source_data_entry.R")
here::i_am("swabs.R")

# Create initial plots
plotA <- ggplot(typeA, aes(id, value)) +
  geom_line(lwd = 1.5, aes(colour = series)) +
  labs(x="Week", y="Number of cases",
       title="UK influenza cases per year",
       subtitle = "(Swabs for type A)",
       caption="As collected by the PHE lab reports") +
  theme_ipsum() +
  scale_x_continuous(breaks = seq(0, 34, 2), 
                     minor_breaks = seq(0, 34, 1),
                     labels = c("40", "42", "44",
                                "46", "48",
                                "50", "52", "2",
                                "4", "6", "8", "10",
                                "12","14","16",
                                "18", "20", "22")) +
  scale_y_continuous(breaks = seq(0, 3500, 1000)) +
  coord_cartesian(ylim = c(0,3500)) +
  theme(panel.border = element_rect(color = "dark grey",
                                    fill = NA,
                                    size = 0.1)) +
  scale_color_manual('Season', values= wes_palette("Moonrise1", n = 4))

plotB <- ggplot(typeB, aes(id, value)) +
  geom_line(lwd = 1.5, aes(colour = series)) +
  labs(x="Week", y="Number of cases",
       title="UK influenza cases per year",
       subtitle = "(Swabs for type B)",
       caption="As collected by the PHE lab reports") +
  theme_ipsum() +
  scale_x_continuous(breaks = seq(0, 34, 2), 
                     minor_breaks = seq(0, 34, 1),
                     labels = c("40", "42", "44",
                                "46", "48",
                                "50", "52", "2",
                                "4", "6", "8", "10",
                                "12","14","16",
                                "18", "20", "22")) +
  scale_y_continuous(breaks = seq(0, 3500, 1000)) +
  coord_cartesian(ylim = c(0,3500)) +
  theme(panel.border = element_rect(color = "dark grey",
                                    fill = NA,
                                    size = 0.1)) +
  scale_color_manual('Season', values= wes_palette("Moonrise1", n = 4))

combined_plot <- ggarrange(plotA, plotB, 
                           ncol = 1, nrow = 2)

combined_plot


