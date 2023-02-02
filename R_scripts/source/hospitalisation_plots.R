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
  geom_line(lwd = 1.5, aes(colour = series)) +
  labs(x="Week", y="Influenza cases UK (cases per 100,000)",
       title="UK influenza cases by year", 
       subtitle = "(Hospitalisation)",
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
  scale_color_manual('Season', values= wes_palette("Moonrise1", n = 4)) +
  coord_cartesian(ylim = c(-0.5, 16), expand = F) +
  scale_y_continuous(breaks = seq(0, 15, 5),
                     minor_breaks = seq(0, 15, 2.5)) +
  scale_fill_manual(values=c("#B7CE89","#FEFF67","#F7B27E",
                            "#CE8282",'#A55E5E' ), name="The MEM threshold",
                    labels = c("Baseline threshold", "Low", "Moderate", 
                               "High", "Very high"),
                    guide = guide_legend(reverse = T))





hospital_plot


########################
# 
# #plot all lines on pne plot
# ggplot(hosp_vis) +
#   theme_minimal() +
#   geom_line(aes(week, hosp_17_18, color = '2017-18')) +
#   geom_line(aes(week, hosp_18_19, color = '2018-19')) +
#   geom_line(aes(week, hosp_19_20, color = '2019-20')) +
#   geom_line(aes(week, hosp_22_23, color = '2022-23')) +
#   guides(color = guide_legend("Season")) +
#   ylab("Influenza cases UK (cases per 100,000)") +
#   # xlim(-12, 20)+
#   ggtitle("UK influenza cases by year (hospitalisation)") +
#   
#   scale_x_discrete(name = "Week",
#                    limits = c("40", "41", "42", "43", "44",
#                               "45", "46", "47", "48", "49",
#                               "50", "51", "52", "1", "2", "3",
#                               "4", "5", "6", "7", "8", "9", "10",
#                               "11", "12", "13", "14", "15", "16",
#                               "17", "18", "19", "20"
#                    ))
# 
# 
# 
# 
# 
#   #Now we're done with tidying, we can plot
#   ggplot() + aes(x=week, y=Rate, colour=`Flu Season`) + geom_line() + theme_minimal() +
#   #Its 4 flu seaseson, so 4 colour values seems appropriate, with colour darkening as we go forward
#   scale_color_manual(values=c( "#8DEEEE","#79CDCD","#528B8B","#2F4F4F")) +
#   scale_x_discrete(name = "Week",
#                    limits = c("40", "41", "42", "43", "44",
#                               "45", "46", "47", "48", "49",
#                               "50", "51", "52", "1", "2", "3",
#                               "4", "5", "6", "7", "8", "9", "10",
#                               "11", "12", "13", "14", "15", "16",
#                               "17", "18", "19", "20"
#                    )) +
#   #labs() allows us labelling control over everything in one place
#   labs(
#     title="UK influenza cases by year (hospitalisation)",
#     subtitle="As reported by UKHSA/PHE",
#     y="Influenza cases UK (cases per 100,000)",
#     coloue="Flu season"
#   ) +
#   #Some aesthetic touched. Not really sure what they add
#   theme( 
#     plot.title = element_text(
#       hjust = 0.5,
#       size = 12,
#       face = "bold",
#       margin = margin(
#         t = 5,
#         r = 0,
#         b = 3,
#         l = 0
#       )
#     ),
#     plot.subtitle = element_text(
#       hjust=0.5
#     ),
#     legend.position = "right",
#     legend.key = element_rect(color = NA),
#     legend.title.align = 0.5,
#     axis.title.x = element_text(
#       margin = margin(t=8, r=0, b=0, l=0)),
#     axis.text.x = element_text(
#       angle = 90,
#       vjust = 0.5,
#       hjust = 1
#     ))
# 
# ggplot(primary_care_vis, aes(x = Weeks, y = Rate) ) +
#   geom_line(lwd = 1.5, aes(colour = `Flu Season`)) +
#   labs(x="Week", y="Rate of consultations (per 100,000)",
#        title="GP consultations for Influenza type illness per 100,000",
#        caption="As collected by the RCGP in England") +
#   theme_ipsum() +
#   scale_x_continuous(breaks = seq(0, 34, 2), 
#                      minor_breaks = seq(0, 34, 1),
#                      labels = c("40", "42", "44",
#                                 "46", "48",
#                                 "50", "52", "2",
#                                 "4", "6", "8", "10",
#                                 "12","14","16",
#                                 "18", "20", "22")) +
#   theme(panel.border = element_rect(color = "dark grey",
#                                     fill = NA,
#                                     size = 0.1)) +
#   geom_ribbon(aes(ymin=0,ymax=12.7,fill="#B7CE89"), alpha=0.25) +
#   geom_ribbon(aes(ymin=12.7,ymax=24.1,fill="#FEFF67"), alpha=0.25)+
#   geom_ribbon(aes(ymin=24.1,ymax=60,fill="black"),  alpha=0.25)+
#   scale_color_manual('Season', values= wes_palette("Moonrise1", n = 4)) +
#   coord_cartesian(ylim = c(0, 60), expand = FALSE) +
#   scale_y_continuous(breaks = seq(0, 60, 10), 
#                      minor_breaks = seq(0, 60, 5)) +
#   scale_fill_manual(values=c("#B7CE89","#FEFF67","#F7B27E"), name="Threshold boundary",
#                     labels = c("Baseline threshold", "Low", "Medium"),
#                     guide = guide_legend(reverse = F))