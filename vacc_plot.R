# Create a plot for vaccination rate stratified by risk groups

vacc_plot <- ggplot(vacc_rate, aes(fill=name, y=value, x=Year)) + 
  xlab("Year") +
  ylab("[%]") +
  ggtitle("Vaccination rate in different risk groups") +
  labs(fill = "") +
  theme_ipsum() +
  theme(panel.border = element_rect(color = "dark grey",
                                    fill = NA,
                                    size = 0.1),
        plot.margin = ggplot2::margin(t = 5, r = 5, b = 7, l = 5),
        panel.grid.major.y = element_line(color = "red",
                                          size = 0.1,
                                          linetype = 2),
        panel.grid.major.x = element_blank(),
        legend.key.size = unit(0.4, 'cm')) +
  geom_bar(position="dodge", stat="identity") +
  scale_fill_manual(values = wes_palette("Moonrise1", n = 4)) +
  scale_x_continuous(breaks = seq(2016,2022,1)) +
  scale_y_continuous(breaks = seq(0,100,20),
                     minor_breaks = seq(0,100,5)) +
  coord_cartesian(ylim = c(0,90), expand = T) 
