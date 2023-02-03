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
