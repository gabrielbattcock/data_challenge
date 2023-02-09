# Gabriel Battcock
# Hospitalistion data UKHSA 

#Reading in 
# here::i_am("R_scripts/source/hospitalisation_plots.R")
# source("R_scripts/source_data_entry.R")




#First, we take the data, and rename the columns so they show up okay in the plot
hosp_vis <- hosp_vis %>% transmute(
  week=week,
  `2017-18`=hosp_17_18,
  `2018-19`=hosp_18_19,
  `2019-20`=hosp_19_20,
  `2022-23`=hosp_22_23)
# pivot_longer(cols=2:5, names_to = "Flu Season", values_to = "Rate")

# Next, we make one outcome table, saves us adding a new geom_line every time
hosp_seasons_melted <- melt(hosp_vis,  id.vars = 'week', variable.name = 'series') 
  
  
#Szymon's plot
hospital_plot <- ggplot(hosp_seasons_melted, aes(week, value) ) +
  geom_line(lwd = 1.5, aes(colour = series), alpha = 0.8) +
  labs(x="Week", y="Rate of hospitalisations (cases per 100,000)",
        title = "Secondary care",
        caption="As reported by UKHSA/PHE") +
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
  geom_ribbon(aes(ymin=-0.5,ymax=0.99,fill="#A55E5E"), alpha=0.25)+
  geom_ribbon(aes(ymin=0.99,ymax=2.65,fill="#B7CE89"), alpha=0.25)+
  geom_ribbon(aes(ymin=2.65,ymax=7.87,fill='#CE8282'), alpha=0.25)+
  geom_ribbon(aes(ymin=7.87,ymax=12.73,fill="#F7B27E"),alpha=0.25)+
  geom_ribbon(aes(ymin=12.73,ymax=16,fill="#FEFF67"), alpha=0.25)+
  scale_color_manual('Season', values = palette_flu) +
  coord_cartesian(ylim = c(-0.5, 16), expand = F) +
  scale_y_continuous(breaks = seq(0, 15, 5),
                     minor_breaks = seq(0, 15, 2.5)) +
  scale_fill_manual(values=c("#B7CE89","#FEFF67","#F7B27E",
                            "#CE8282",'#A55E5E' ), name="The MEM threshold",
                    labels = c("Baseline threshold", "Low", "Moderate", 
                               "High", "Very high"),
                    guide = guide_legend(reverse = F, order = 2))

hospital_plot
