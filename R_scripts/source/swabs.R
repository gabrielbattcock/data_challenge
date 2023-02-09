# Szymon Jakobsze
# Flu swab data UKHSA & Datamart

# here::i_am("R_scripts/source/swabs.R")
# source("R_scripts/source_data_entry.R")


# Create initial plots
plotA <-  ggplot(typeA, aes(id, value)) +
  geom_line(lwd = 1.5, aes(colour = series), alpha = 0.7) +
  labs(x="Week", y="Number of cases",
       title="Type A")+
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
  scale_color_manual('Season', values = palette_flu) +
  theme(plot.margin = margin(t = 5,
                             r = 3,  
                             b = 5, 
                             l = 3))



plotB <- ggplot(typeB, aes(id, value)) +
  geom_line(lwd = 1.5, aes(colour = series), alpha =0.7) +
  labs(x="Week", y="Number of cases",
       title="Type B")+
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
  scale_color_manual('Season', values = palette_flu) +
  theme(plot.margin = margin(t = 5,
                       r = 3,  
                       b = 5, 
                       l = 3))





combined_plot <- ggarrange(plotA, plotB,
                           ncol = 2, nrow = 1,
                           common.legend = TRUE,
                           legend = "bottom")

combined_plot


