## Methods of analysis

### $$R_{eff} $$ation

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
