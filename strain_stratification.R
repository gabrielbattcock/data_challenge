# Szymon Jakobsze
# Strain stratified data for swab testing schemes and hospitalisations 

# source("R_scripts/source_data_entry.R")
# here::i_am("source_data_entry.r")

###################################SWAB DATA####################################

# Load scraped data for seasons 2017-19
path_swabs <- here("allData","swab","swabs_strains_2017_2019.csv")

strains17_19_swabs <- path_swabs %>% read_csv()
palette_flu <- c("#00425A", "#1F8A70", "#BFDB38", "#FC7300")

# Data cleaning

# Swabs data 17-18 season
strains17_18_swabs <- strains17_19_swabs %>% slice(1:33) %>% select(-year,-week) 
strains17_18_swabs <- mutate(strains17_18_swabs, id = seq.int(nrow(strains17_18_swabs)), .before = 1) %>%
                      relocate(a_h1n1, .before = a_h3) %>% 
                      melt(id.vars = 'id',variable.name = 'series')
                    
    
# Swabs data 18-19 season
strains18_19_swabs <- strains17_19_swabs %>% slice(34:66) %>% select(-year,-week)
strains18_19_swabs <- mutate(strains18_19_swabs, id = seq.int(nrow(strains18_19_swabs)), .before = 1) %>%
                      relocate(a_h1n1, .before = a_h3) %>% 
                      melt(id.vars = 'id',variable.name = 'series')

# Swabs data 19-20 season
strains19_20_swabs <- as_tibble(df_list_201920$UK_GP_Swabbing_Schemes) %>% 
                      select(
                        a_h1n1 = `A(H1N1)` ,
                        a_h3 = `A(H3)`,
                        a_unknown = `A(unknown)`,
                        b = B)

strains19_20_swabs[is.na(strains19_20_swabs)] <- 0

strains19_20_swabs %<>% mutate(id = seq.int(nrow(strains19_20_swabs)), .before = 1) %>% 
                        melt(id.vars = 'id',variable.name = 'series')


# Swabs data 22-23 season
strains22_23_swabs <- as_tibble(df_list_2023$`Figure_10__Datamart_-_Flu`)

strains22_23_swabs[is.na(strains22_23_swabs)] <- 0

strains22_23_swabs %<>% slice(14:46) %>% 
                        select(
                          a_h1n1 = `Influenza A(H1N1)pdm09 (n)` ,
                          a_h3n2 = `Influenza A(H3N2) (n)`,
                          a_unknown = `Influenza A(not subtyped) (n)`,
                          b = `Influenza B (n)`)
  
strains22_23_swabs %<>%  mutate(id = seq.int(nrow(strains22_23_swabs)), .before = 1) %>% 
                         melt(id.vars = 'id',variable.name = 'series')
                                                                      


############################HOSPITALISATIONS####################################

# Data cleaning

# Hospitalisation data stratified by flu strain is only avaialble for 2017-18
path_hosp <- here("allData", "hospitalisation", "2017-18_flu_hospital_data.csv")

strains17_18_hosp <- path_hosp %>% 
                     read_csv() %>% 
                     select(
                       "A H1N1"= `sent_H1N1pdm09` ,
                       a_h3n2 = `sent_H3N2`,
                       a_unknown = `sent_A_unknown`,
                       b = `sent_B`) 
                      

strains17_18_hosp[is.na(strains17_18_hosp)] <- 0

strains17_18_hosp %<>% mutate(strains17_18_hosp, id = seq.int(nrow(strains17_18_hosp)), .before = 1) %>% 
                       melt(id.vars = 'id',variable.name = 'series')


############################DATA VISUALISATION##################################


# Hospitalisations 

strains17_18_hosp_plot<- ggplot(strains17_18_hosp, aes(id, value)) +
  geom_line(lwd = 1.5, aes(colour = series)) +
  labs(x="Week", y="Number of cases",
       title="UK influenza hospitalisations in the season 2017-2018",
       subtitle = "Stratified by flu strain",
       caption="As collected by the ") +
  theme_ipsum() +
  scale_x_continuous(breaks = seq(0, 34, 2), 
                     minor_breaks = seq(0, 34, 1),
                     labels = c("40", "42", "44",
                                "46", "48",
                                "50", "52", "2",
                                "4", "6", "8", "10",
                                "12","14","16",
                                "18", "20", "22")) +
  scale_y_continuous(breaks = seq(0, 500, 100)) +
  coord_cartesian(ylim = c(0,500)) +
  # theme(panel.border = element_rect(color = "dark grey",
  #                                   fill = NA,
  #                                   linewidth = 0.1)) +
  scale_color_manual('Strain', values = palette_flu)


# Swabs

# 2017 - 2018 season 

strains17_18_swabs_plot<- ggplot((strains17_18_swabs %>% slice(1:132)) , 
                                 aes(id, value)) +
  geom_line(lwd = 1.5, aes(colour = series), alpha = 0.6) +
  labs(x="Week", y="Number of cases") +
       # ,
       # title="UK influenza laboratory confirmed cases in the season 2017-2018",
       # subtitle = "Stratified by flu strain",
       # caption="As collected by the Datamart scheme") +
  theme_ipsum() +
  scale_x_continuous(breaks = seq(0, 34, 2), 
                     minor_breaks = seq(0, 34, 1),
                     labels = c("40", "42", "44",
                                "46", "48",
                                "50", "52", "2",
                                "4", "6", "8", "10",
                                "12","14","16",
                                "18", "20", "22")) +
  # theme(panel.border = element_rect(color = "dark grey",
  #                                   fill = NA,
  #                                   linewidth = 0.1)) +
  scale_color_manual('Strain', values= palette_flu)


# 2018 - 2019 season 

strains18_19_swabs_plot <- ggplot((strains18_19_swabs %>% slice(1:132)) , 
                                 aes(id, value)) +
  geom_line(lwd = 1.5, aes(colour = series), alpha = 0.6) +
  labs(x="Week", y="Number of cases") +
       # ,
       # title="UK influenza laboratory confirmed cases in the season 2018-2019",
       # subtitle = "Stratified by flu strain",
       # caption="As collected by the Datamart scheme") +
  theme_ipsum() +
  scale_x_continuous(breaks = seq(0, 34, 2), 
                     minor_breaks = seq(0, 34, 1),
                     labels = c("40", "42", "44",
                                "46", "48",
                                "50", "52", "2",
                                "4", "6", "8", "10",
                                "12","14","16",
                                "18", "20", "22")) +
  # theme(panel.border = element_rect(color = "dark grey",
  #                                   fill = NA,
  #                                   linewidth = 0.1)) +
  scale_color_manual('Strain', values= palette_flu)



# 2019 - 2020 season 

strains19_20_swabs_plot <- ggplot((strains19_20_swabs %>% slice(1:132)) , 
                                  aes(id, value)) +
  geom_line(lwd = 1.5, aes(colour = series), alpha = 0.6) +
  labs(x="Week", y="Number of cases") +
       # ,
       # title="UK influenza laboratory confirmed cases in the season 2019-2020",
       # subtitle = "Stratified by flu strain",
       # caption="As collected by the Datamart scheme") +
  theme_ipsum() +
  scale_x_continuous(breaks = seq(0, 34, 2), 
                     minor_breaks = seq(0, 34, 1),
                     labels = c("40", "42", "44",
                                "46", "48",
                                "50", "52", "2",
                                "4", "6", "8", "10",
                                "12","14","16",
                                "18", "20", "22")) +
  # theme(panel.border = element_rect(color = "dark grey",
  #                                   fill = NA,
  #                                   linewidth = 0.1)) +
  scale_color_manual('Strain', values= palette_flu)

# 2022 - 2023 season 

strains22_23_swabs_plot <- ggplot((strains22_23_swabs %>% slice(1:132)) , 
                                  aes(id, value)) +
  geom_line(lwd = 1.5, aes(colour = series), alpha = 0.6) +
  labs(x="Week", y="Number of cases") +
       # ,
       # title="UK influenza laboratory confirmed cases in the season 2022-2023",
       # subtitle = "Stratified by flu strain",
       # caption="As collected by the Datamart scheme") +
  theme_ipsum() +
  scale_x_continuous(breaks = seq(0, 34, 2), 
                     minor_breaks = seq(0, 34, 1),
                     labels = c("40", "42", "44",
                                "46", "48",
                                "50", "52", "2",
                                "4", "6", "8", "10",
                                "12","14","16",
                                "18", "20", "22")) +
  # theme(panel.border = element_rect(color = "dark grey",
  #                                   fill = NA,
  #                                   linewidth = 0.1)) +
  scale_color_manual('Strain', values = palette_flu)


combined_strain_plot <- ggarrange(strains17_18_swabs_plot, strains18_19_swabs_plot,
                                strains19_20_swabs_plot, strains22_23_swabs_plot,
                                ncol = 2, nrow = 2, 
                                common.legend = TRUE, legend="bottom",
                               labels = c("2017-18", "2018-19", "2019-20", "2022-23"))

combined_strain_plot
#combined_strain_plot %>% annotate_figure(top = text_grob("UK influenza laboratory confirmed cases, stratified by flu strain"),
 #                                        bottom = text_grob("As collected by the Datamart scheme",
  #                                                          hjust = 1, x = 1, face = "italic", size = 10))


palette_flu <- c("#00425A", "#1F8A70", "#BFDB38", "#FC7300")
