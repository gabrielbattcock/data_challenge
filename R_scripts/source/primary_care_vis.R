


# #Primary care vis (Szymon's version)
# here::i_am("R_scripts/souce/primary_care_vis.R")
# source("R_scripts/source_data_entry.R")


gp_cases <- ggplot(primary_care_melted, aes(x = id, y = value) ) +

  geom_line(lwd = 1.5, aes(colour = `series`), alpha = 0.8) +
  labs(x="Week", y="Rate of consultations (cases per 100,000)",
        title="Primary care",
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
  geom_ribbon(aes(ymin=0,ymax=12.7,fill="#B7CE89"), alpha=0.25) +
  geom_ribbon(aes(ymin=12.7,ymax=24.1,fill="#FEFF67"), alpha=0.25)+
  geom_ribbon(aes(ymin=24.1,ymax=60,fill="black"),  alpha=0.25)+
  scale_color_manual('Season', values= palette_flu) +
  coord_cartesian(ylim = c(0, 60), expand = FALSE) +
  scale_y_continuous(breaks = seq(0, 60, 10), 
                     minor_breaks = seq(0, 60, 5)) +
  scale_fill_manual(values=c("#B7CE89","#FEFF67","#F7B27E"), name="The MEM threshold",
                    labels = c("Baseline threshold", "Low", "Medium"),

                    guide = guide_legend(reverse = F, order = 2))
gp_cases

