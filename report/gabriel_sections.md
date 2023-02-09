## Abstract



Influenza is a group of viruses that circulates seasonally throughout the world. Severe cases might require hospitalisation and can progress to death. This is a particular concern for at-risk groups, which include children \\\<2 years of age; pregnant women; the elderly \\\>65yo; and patients with comorbidities. The UK's influenza surveillance system is multi-faceted with the main influenza reporting sources being GP consultations of Influenza like Illness, hopsitalisations and through a national swabbing report. Throughout this report, we investigate whether there is a temporal relationship between these data sources. By plotting and using stastical analysis on the data


We hypothesise that there exists a temporal relationship between sources of surveillance. Statistical tools can then be applied to predict the timing and scale of a 'later' data source using an 'earlier' source. Additionally, different age groups can manifest at different time and scale, and one might be predictive of another. Additionally, we suspect changes in reporting procedures of respiratory infections post-covid may cause differences with pre-pandemic data

#### Data Processing

The data used in this project is publicly available on various governmental websites. Primary care data is published weekly by the RCGP Research and Surveillance Centre in the communicable and respiratory disease reports. Laboratory confirmed cases are reported weekly by UKHSA. Secondary care data is extracted from the UKHSA Severe Acute Respiratory Infection Watch (SARI Watch) system, updated weekly during the influenza season (week 40 - week 20 next year). Mortality data is reported weekly by the ONS. All cleaning and processing are done using the R language.

#### Analysis

At first glimpse, the peak for each data source does not differ much from each other in a given year.

Cross-correlation between two data sources can be measured using Spearman's \$ρ\$, a non-parametric test of correlation. To ascertain the pairwise time lag (if any), Spearman's test is run repeatedly with a gradually increasing lag. The lag value associated with the best \$ρ\$ is reported as the lag between given sources for a given year.


\*\--page break\--\*

## Methods of analysis

### $R_\text{eff}$ation

To further investgate the temporal relationships between the data sources, an effective reproduction number has been calculated. This can be inferred from the observed exponential growth rate seen at the beginning of a flu epidemic. The observed reproduction number $R$ can be found through the linear equation:

$R = 1 + \frac{r}{b}$ ,

where $r$ is the rate of exponential growth and $b$ is the rate of leaving the infectious stage [@Lipsitch]. By approximating the beginning of the growth curves as $N=ke^{ \frac{rt}{b}}$ (where $k$ a constant), the value $\frac {r}{b}$ can be found from the gradient when plotting $\log (N)$ against $t$.

In practice, log graphs were plotted and a linear model was fitted to the points at the beginning of the epidemic. Using the gradient, the $R_{eff}$ was calculated for each data source, each season.

## data extraction

PHE and the UKHSA use the Moving Epidemic Method (MEM) to report the severity of the epidemic season. This is calculated using through using previous epidemic activity [\@Rachovic].

From for each of the data sources presented, we have used the MEM calculated and published by PHE and the UKHSA respectively in their weekly national flu reports.

## methods of extraction

To study the temporal relationship between data sources, three differing flu data sources have been used: primary care, secondary care and laboratory confirmed swab results. Primary care data was reported by the Royal College of General Practitioners (RCGP) Research and Surveillance Centre communicable and respiratory disease reports. In this report, cases of Influenza Like Illnesses (ILI) that present in GP practices participating in the scheme are collected and reported for England and Wales [\@RCGP].

Secondary care data is extracted from the UKHSA Severe Acute Respiratory Infection Watch system.

### Log graphs

To estimate the effective reproduction number between each of the data sources, the case rate per 100,000 was transformed using a natural logarithm and plotted against epidemiological week. The log plot resulted in a straight line during the initial exponential growth period and a tail after the peak of infections, as was expected from theory. The plots were evaluated to find which weeks to fit a linear model to. Using the linear model function in R, a line was overlaid on the log plots and coefficients of gradients for each of the lines were extracted. Using $R = 1 + \frac{r}{b}$, as detailed above, the $R_{eff}$ was calculated.

The estimated $R_{eff}$ for each year and data source is detailed below. As expected at the beginning of a flu season, the R numbers are all above 1. It is noted that a higher reproduction number calculated for the data from hospitalisations than from GP consultations.

### maybe discussion section

While the calculation is a simple approximation for the effective reproduction number, the resultant numbers are

## Results

### Stratification by age

Using data provided by the RCGP, flu data has been plotted stratified by age. This has been reported as ILI rate per 100,000, and broken down in to three age groups: \\\<15 years, 15-64 years and 65+ years.

For the season 2017-18, there is a lag between the peaks of adults older than 15 years and children. The large growth of the epidemic this season begins at week 50 and peaks at week 3 for all ages except \\\<15 years which peak at week 5. This may be due to the timing of the epidemic overlapping with UK school holidays, leading children to having less social interaction, therefore delaying their peak by two weeks.

For the season 2018-19 there appears to be a minor peak followed by a larger peak a few weeks later. This year, the second peak among the 65+ age group lags behind all other age groups by a week. This may be due to less socialising among the older age group.

The season 2019-20 shows multiple peaks with the expected dip over the holiday period (between weeks 51-1). As with the 2018-19 season, the 65+ age group lag behind the other age groups, with the largest peak for this age group two weeks after all other ages. There is also an evident spike at week 12 for this year. As this data is recording "Influenza *like* illness", it can be assumed that this peak is due to the COVID-19 pandemic.

The current flu season also shows a lag in growth among the 65+ group. The data however does not go up show where the peaks are, so we do not know the full picture. It is also shown that the under 15 years have a lower gradient after week 51 around the winter holidays begin.

## Discussion

From analysis of the plots for each season stratified by the source of data, there is no apparent temporal difference in the peaks for rate of influenza cases. Although our sample size of four season is small, this appears to suggest that there is no temporal relation between different influenza data sources. While we see no visible lag between peaks in the population as a whole, the data was probed further to try to discover any other temporal relationship.

**interpretation of the corr**

The reproduction number has been estimated for each of the seasons and each of the data sources. Through the use of a linear model, the gradient has been extracted to then be used to calculate the effective $R$ number. From the results calculated, it is clear that the estimate is larger for both hospitalisation data and swab data than for the GP data. The calculation here is a simplistic approximation for the reproduction number but does show that the spread of cases is slower for GP consultations which is more indicative of the general population as not everyone who goes to a GP for flu symptoms will be referred to hospital. This also gives some evidence towards a temporal relationship between GP consultations and hospitalisations, as knowing when there is a rise in the cases in GPs infers that there will be a large rise in hospitalisation following. As the calculation is not a complex model to estimate the reproduction number for influenza but does give a good estimate to be used in the report. Estimating the reproduction number for a virus such as influenza can be difficult due as it is uncertain the level of immunity among the population. While it may help throughout the report to have more granularity of data, it may not give a better estimate of the reproduction number. The results have assisted in showing a temporal relationship between GP cases and hospitalisations.

### Hypothesis and purpose of study

The hypothesis to the main research question was that we expected there to be a temporal difference between peaks from different data sources, specifically that hospitalisations may lag behind GP cases. From the plots for each season stratified by the source, other than in 2022-23, there is no clear change in the timing of the peaks. The maximum rate of cases occurs on the same week for each of the remaining seasons investigated in this report. Our hypothesis was on the basis that influenza symptoms take time to become severe enough to result in hospitalisation, leading to a lag. However, it is known that the incubation period of influenza is between 0.6 and 1.4 days and most people will recover within a week [@Lancet2022]. Due to this, it is not so surprising that there is no obvious lag between data sources as the time frame may not small enough to capture any differences between peaks. Any delay in reporting cases from any of the sources would add to this opacity. Therefore, there is no temporal relationship present in the data presented in this report for a population as a whole. GP consultations are not considered to be a good predictor of hospitalisation cases for influenza.

With regards to the secondary research questions and hypotheses, the data gives more insight. When RP consultations are stratified by age group, there is a clear lag between the 65+ years and the remaining age groups in all years other than the season 2017-18. However, the one season where \<15 years lag behind the other age groups can be explained due the peak of infections happening over the holiday period when schools are closed. When schools are closed, younger people have fewer social contacts and are therefore less likely to spread influenza. A delayed peak occurring after the return to school, as shown in the plots, is to be expected. Referring back to the seasons 2018-19, 2019-20 and 2022-23, the lag of the age group 65+ is also to be expected. For a similar reasoning, 65+ age group will tend to have fewer social interactions than children, so will have a slower spread of influenza. Therefore, knowing that cases are rising among \<15 years can help predict a peak in the 65+ age group, who also would tend to be more severely affected by influenza.

The data presented in this report should help the UKHSA plan for oncoming influenza peaks. While we cannot say that looking at GP data will help show an oncoming peak in hospitalisations, looking at stratified age group data may help predict a peak in older age groups.

Future work

It has been reported in the past that different strains of influenza may have a different distribution between different age groups [@Age2015]. It could be useful in the future to have cases reported by both strain and age group so that any differences can be studied. This may also contribute to a temporal difference and could help prepare for rise in cases as some strains have a higher hospitalisation rate than others.

As COVID-19 becomes endemic within the population, it will be important for the UKHSA to know the temporal relationship between both diseases. COVID combined with influenza has potential to cause many hospistalisations. Therefore, studying a temporal relationship of influenza and COVID-19 for each data source could help preparedness.

Due to the UKHSA being a UK based agency, the data used within this report is from England. Influenza circulates around the world and is tracked by many governmental bodies. While acknowledging the different structure of the UK health system (with primary care referrals), it may also be worth studying temporal differences between influenza data sources in other countries.

#### take home/conclusion

Influenza is a very difficult disease to study and predict due to reasons include the different strains, antigenic shift and the unknown level of immunity in a given season. While data for previous seasons can be studied, the complex nature and changes from season to season mean it is difficult to give a firm prediction of what could happen in the future. While the data shows that there no noticeable lag in peaks between any of the data sources, there is a lag in GP cases among different age groups. There is also a noticeable difference also in the rate of spread reported between GP cases and hopsitalisation cases.

\-\-\-\-\-\--

From analysis of the plots for each season stratified by the source of data, there is no apparent temporal difference in the peaks for rate of influenza cases. Although our sample size of four season is small, this appears to suggest that there is no temporal relation between different influenza data sources. While we see no visible lag between peaks in the population as a whole, the data was probed further to try to discover any other temporal relationship.
interpretation of the corr
The reproduction number has been estimated for each of the seasons and each of the data sources. Through the

use of a linear model, the gradient has been extracted to then be used to calculate the effective \$R\$ number. From the results calculated, it is clear that the estimate is larger for both hospitalisation data and swab data than for the GP data. The calculation here is a simplistic approximation for the reproduction number but does show that the spread of cases is slower for GP consultations which is more indicative of the general population as not everyone who goes to a GP for flu symptoms will be referred to hospital. This also gives some evidence towards a temporal relationship between GP consultations and hospitalisations, as knowing when there is a rise in the cases in GPs infers that there will be a large rise in hospitalisation following. As the calculation is not a complex model to estimate the reproduction number for influenza but does give a good estimate to be used in the report. Estimating the reproduction number for a virus such as influenza can be difficult due as it is uncertain the level of immunity among the population. While it may help throughout the report to have more granularity of data, it may not give a better estimate of the reproduction number. The results have assisted in showing a temporal relationship between GP cases and hospitalisations.

### Strat by strain

This figure plots total recorded influenza cases by week in the influenza season (defined as the 40th week of the previous year to the 20th week of the subsequent), separated by strain of influenza for each included influenza season as recorded by Datamart scheme. The season 2017-18 shows a type B influenza dominant year. The earliest rise in cases was observed in the A H3 subtype, whilst the other strains present a delay of approximately one week. Moving forward in the season, week 49 brings increase in growth of the number of cases for type B and A H3 subtype. This was the key significant period for both A H3 subtype and B type, which went onto reach their peaks in week 2 and 3 respectively. Peak number of cases for A H3 subtype reached almost 350 and more than 600 cases for type B. Immediately after its peak, cases of type B influenza started decreasing gradually, with occasional increases in week 8, reaching 400 cases and in week 11 reaching approximately 250 cases. A similar trend was observed in the incidence of the A H3 subtype influenza which decreased in week 6 to 200 cases and fluctuated between 250-170 for the next six weeks. An important point is that the H1N1 type A starts to plateau around week 2 of 2018, reaching a point of approximately 50 cases daily, a threshold that was never surpassed again throughout the season. The unknown A type reaches its peak of 150 cases in week 6 to later fluctuate between 50-100 cases until week 15, when it gradually started to drop.

For the season 2018 -19 the available data was strafed only by two types - A (unknown subtype) and B. During this season incidence of type B influenza reached a maximum of 11 cases in 45th week and did not pass the threshold of 10 after. Growth in incidence of type A influenza started at week 44 and continued, with a steeper rise starting in week 51 when over 300 new cases were recorded. This strain has dominated the season soaring at nearly 800 cases in week 3. After a slight dip during the next week, incidence of the unknown type A influenza peaked during week 7 with almost 1250 of new cases. It started plummeting until week 10 and gradually decreased until the end of the season.

Cases of A H1N1, unknown type A and type B caused only minor burden in season 2019-20 in comparison to the A H3 subtype. All of the analysed strains apart from A H3 seem to be fluctuating around 10-30 cases between week 43 of 2019 and week 9 of 2020. Incidence of A H3 started to rise during the week 43 of the season and peaked in week 52. After its peak it has dropped rapidly to eventually level off during week 5 and fluctuate around the same incidence.

In the only season after the COVID-19 pandemic, season 2022 - 2023, we can observe that both type B influenza and the A H1N1 subtype represented only a fraction of all incidence, reaching approximately 50 cases each during 52nd week. The most dominant strain of the season was unknown type A influenza, which was on the rise since the first week of the season. During 50th week cases started soaring until incidence of the type A influenza reached its peak of almost 2300 new cases in week 52 of 2022. Second most dominant strain of the season - A H3 presented slower rise, starting in week 46 and peaking at 1250 new cases at the same time as type A - week 52. Data in the graph only represents incidence until week 5 of the year 2023 and that's when we can observe a decline in all of the cases.

### Title

What is the temporal relationship between different influenza data sources (lab-confirmed infections, GP consultations, hospitalisations) in the UK, and have these changed in 2022/23 compared to the pre-pandemic years 2017-2020?
