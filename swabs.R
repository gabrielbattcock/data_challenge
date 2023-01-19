# Szymon Jakobsze
# Flu swab data UKHSA & Datamart

library(pacman)
p_load(tidyverse, here, viridis, hrbrthemes, reshape2, ggpubr, wesanderson)

here::i_am("swabs.R")
#Aizaz started to copy here for source_data_entry
swabs <- tibble(read_csv(here("allData", "swab", "2014 - 2021 swab data.csv")))
swabs <- swabs[,-1] %>% select(-year, -week) 

swab_season17_18 <- swabs %>% slice(175:207)
swab_season18_19 <- swabs %>% slice(227:259)
swab_season19_20 <- swabs %>% slice(279:311)

swab_season22_23 <- tibble(df_list_2022$`Figure_10__Datamart_-_Flu`) %>% 
                    slice(14:46) 

# Add some supplementary data from the 2023
path <- "weekly_report_flu_2023.xlsx"
df_list_2023 <- list()

sheet_vector_2023 <- path %>% excel_sheets()

for (i in 1:length(sheet_vector_2023)) {
  
  df_list_2023[[i]] <- tibble(read_xlsx(path, sheet_vector_2023[i], skip=7))
}
names(df_list_2023) <- sheet_vector_2023

supplement_data_2023 <- df_list_2023$`Figure_10__Datamart_-_Flu`

swab_season22_23[14,2:5] <- supplement_data_2023[27,2:5]

swab_season22_23$flu_A <- rowSums(swab_season22_23[2:4])
colnames(swab_season22_23)[5] = 'flu_B'

swab_season22_23 <- swab_season22_23 %>% select ( flu_A,
                                                  flu_B)



# Add id number to plot the data
swab_season17_18$id <- 1:nrow(swab_season17_18)
swab_season18_19$id <- 1:nrow(swab_season18_19)
swab_season19_20$id <- 1:nrow(swab_season19_20)
swab_season22_23$id <- 1:nrow(swab_season22_23)

#Aizaz stopped copying here for source_data_entry

# Create data frames for 2 separate flu types
typeA1 <- tibble(id = swab_season17_18$id,
                '17-18' = swab_season17_18$flu_A,
                '18-19' = swab_season18_19$flu_A,
                '19-20' = swab_season19_20$flu_A,
                '22-23' = swab_season22_23$flu_A)

typeA <- melt(typeA1 ,  id.vars = 'id', variable.name = 'series')

typeB1 <- tibble(id = swab_season17_18$id,
                '17-18' = swab_season17_18$flu_B,
                '18-19' = swab_season18_19$flu_B,
                '19-20' = swab_season19_20$flu_B,
                '22-23' = swab_season22_23$flu_B)

typeB <- melt(typeB1 ,  id.vars = 'id', variable.name = 'series')

# Create initial plots
plotA <- ggplot(typeA, aes(id, value)) +
  geom_line(lwd = 1.5, aes(colour = series)) +
  ggtitle("Positive influenza type A test results") +
  theme_ipsum_rc() +
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
  theme_ipsum_rc() +
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
        scale_color_manual('Season', values= wes_palette("GrandBudapest1", n = 4))

combined_plot <- ggarrange(plotA, plotB, 
                ncol = 1, nrow = 2)
combined_plot
