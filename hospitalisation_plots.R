# Gabriel Battcock
# Hospitalistion data UKHSA 

#Reading in 
source("source_data_entry.R")
here::i_am("hospitalisation_plots.R")

#plot all lines on pne plot
ggplot(hosp_seasons) +
  theme_minimal() +
  geom_line(aes(week, hosp_17_18, color = '2017-18')) +
  geom_line(aes(week, hosp_18_19, color = '2018-19')) +
  geom_line(aes(week, hosp_19_20, color = '2019-20')) +
  geom_line(aes(week, hosp_22_23, color = '2022-23')) +
  guides(color = guide_legend("Season")) +
  ylab("Influenza cases UK (cases per 100,000)") +
  # xlim(-12, 20)+
  ggtitle("UK influenza cases by year (hospitalisation)") +

  scale_x_discrete(name = "Week",
                   limits = c("40", "41", "42", "43", "44",
                              "45", "46", "47", "48", "49",
                              "50", "51", "52", "1", "2", "3",
                              "4", "5", "6", "7", "8", "9", "10",
                              "11", "12", "13", "14", "15", "16",
                              "17", "18", "19", "20"
                              ))


#Aizaz variation on hospitalisation data. Please run all below
#First, we take the data, and rename the columns so they show up okay in the plot
hosp_seasons %>% transmute(
  week=week,
  `2017-18`=hosp_17_18,
  `2018-19`=hosp_18_19,
  `2019-20`=hosp_19_20,
  `2022-23`=hosp_22_23
) %>%
  #Next, we make one outcome table, saves us adding a new geom_line every time
  pivot_longer(cols=2:5, names_to = "Flu Season", values_to = "Rate") %>%
  #Now we're done with tidying, we can plot
  ggplot() + aes(x=week, y=Rate, colour=`Flu Season`) + geom_line() + theme_minimal() +
  #Its 4 flu seaseson, so 4 colour values seems appropriate, with colour darkening as we go forward
  scale_color_manual(values=c( "#8DEEEE","#79CDCD","#528B8B","#2F4F4F")) +
  scale_x_discrete(name = "Week",
                   limits = c("40", "41", "42", "43", "44",
                              "45", "46", "47", "48", "49",
                              "50", "51", "52", "1", "2", "3",
                              "4", "5", "6", "7", "8", "9", "10",
                              "11", "12", "13", "14", "15", "16",
                              "17", "18", "19", "20"
                   )) +
  #labs() allows us labelling control over everything in one place
  labs(
    title="UK influenza cases by year (hospitalisation)",
    subtitle="As reported by UKHSA/PHE",
    y="Influenza cases UK (cases per 100,000)",
    coloue="Flu season"
  ) +
  #Some aesthetic touched. Not really sure what they add
  theme( 
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
