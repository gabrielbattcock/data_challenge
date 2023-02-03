---
version: 0.3.0
author: GB, AC, SJ, HL
---

[TOC]

# Data_Challenge

## Project Overview

[copy-paste from the report]

Influenza is a highly infectious disease caused by a family of virus under the same name. Up to 650,000 deaths yearly can be directly attributed to seasonal outbreaks of influenza worldwide. The virus has multiple species, with type A and type B being predominant in spreading among human. Progression of flu is usually self-limiting. For most, symptoms last for 2~7 days. Severe cases might require hospitalisation, or even deaths, particularly for at-risk groups (children <2 yo, pregnant, elderly >65yo, and people with underlying conditions). 

The UK's flu surveillance system comprises of numerous different input points. For example, weekly % of  GP consultations  presenting with influenza-like illnesses (ILI), or death registrations where the leading cause is flu. To better understand and compare these data sources, we defined our research question as follows:

> What is the temporal relationship between different influenza data sources (lab-confirmed infections, GP consultations, hospitalisations) in the UK, and have these changed in 2022/23 compared to the pre-pandemic years 2016-2019?

We hypothesise that there is a measurable lag between one source of surveillance and another. Statistical tools can then be applied to predict the timing and scale of a 'later' data source using an 'earlier' source. Additionally, different age groups can manifest at different time and scale, and one might be predictive of another. Also, changes in reporting procedures on respiratory infections in the recent years (post-covid) is also suspected to be causing some variations in data. 

### Data Processing

All data used in this project were publicly available on various governmental websites. 

Primary care data was reported by the RCGP Research and Surveillance Centre in the communicable and respiratory disease reports, published weekly. Swabs data is reported weekly by PHE. Secondary care data is extracted from the UKHSA Severe Acute Respiratory Infection Watch (SARI Watch) system, updated weekly during the flu season (week 40 - week 20 next year). Mortality data is reported weekly by the ONS. 

All cleaning and processing are done using the R language and the RStudio IDE. 



## How to use this script

### 0. Shiny App

You can play with the web application, powered by R-Shiny, without the need to download any part of the project. 

Really?

### 1. Download

If you have SSH configured, great, just fire up the terminal

```shell
$ cd ~/YOUR/PATH
$ git clone git@github.com:gabrielbattcock/data_challenge.git
```

If you don't, all is not lost my friend, you still need to 

```shell
$ cd ~/YOUR/PATH
$ git clone https://github.com/gabrielbattcock/data_challenge.git
```

### 2. Dependencies

This project cannot be built without the numerous packages from the R community. We use `pacman::p_load()` to install if needed, and load these packages without user intervention. If you prefer to install these selectively or individually, below is a comprehensive list of the packages, grouped by purpose.

- **GENERAL PURPOSE**
  - [Tidyverse (core)](https://www.tidyverse.org/packages/)
  - [pacman](https://cran.r-project.org/web/packages/pacman/index.html) for loading and installing packages
  - [Knitr](https://cran.r-project.org/web/packages/knitr/index.html) for dynamic report generation
  - [shiny](https://cran.r-project.org/web/packages/shiny/index.html) to build interactive web applications
- **READING FILES**
  - [curl](https://cran.r-project.org/web/packages/curl/index.html) for downloading files
  - [here](https://cran.r-project.org/web/packages/here/index.html) for locating files relative to project root path
  - [openxlsx](https://cran.r-project.org/web/packages/openxlsx/index.html) for reading MS Excel `.xlsx` with the option to fill in merged cells
  - [readxl](https://cran.r-project.org/web/packages/openxlsx/index.html) for reading MS Excel .`xls` (legacy) and `.xlsx`
  - [readODS](https://cran.r-project.org/web/packages/readODS/index.html) for reading OpenDocument Spreadsheet `.ods` into R as data frame
- **DATA MANIPULATION**
  - [Reshape2 \[retired]](https://cran.r-project.org/web/packages/reshape2/index.html) for `melt()`
  - [Magrittr](https://magrittr.tidyverse.org/) for the almighty double pipe `%<>%`
  - [kableExtra](https://cran.r-project.org/web/packages/kableExtra/index.html) to construct complex tables within the pipe syntax
- **STATISTICAL ANALYSIS**
  - [mada](https://cran.r-project.org/web/packages/mada/index.html) for metą-analysis of diagnostic accuracy
  - [RcppRoll](https://cran.r-project.org/web/packages/RcppRoll/index.html) for rolling average
- **VISUALISATION**
  - [ggrepel](https://cran.r-project.org/web/packages/ggrepel/index.html) to avoid overlapping text labels 
  - [ggpubr](https://cran.r-project.org/web/packages/ggpubr/index.html) for publication-ready plots
  - [gt](https://cran.r-project.org/web/packages/gt/index.html) for presenting tables
  - [gtsummary](https://cran.r-project.org/web/packages/gtsummary/index.html) for presenting data summary and analytic results
  - [hrbrthemes](https://cran.r-project.org/web/packages/hrbrthemes/index.html) for additional themes and utils for `ggplot2`
  - [RColorBrewer](https://cran.r-project.org/web/packages/RColorBrewer/index.html) for additional colour schemes 
  - [robvis](https://cran.r-project.org/web/packages/RColorBrewer/index.html) for risk-of-bias (ROB) assessments
  - [scales](https://cran.r-project.org/web/packages/scales/index.html) to map data to aesthetics
  - [wesanderson](https://cran.r-project.org/web/packages/wesanderson/index.html) for Wes Anderson inspired palettes and themes
### 3. Running the code

**You don't need to run `source_data_entry.R` by itself. **

**Load the `.Rproj`, then just open the script. It will `source()` the data that's needed.**

With in the directory `../R_scripts`, there is a script called `source_data_entry.R` which gathers the various files in `../allData` that we have collected and outputs data frames which are used throughout the rest of the project. 

The remainder of the code are saved under folders named by their purpose. Refer to `../R_scripts/Season_data` for plots and analysis comparing each source over a season or in `../R_scripts/source`, which compares the seasons for a given source, such as GP data. 

### 4. Directory Tree

```
data_challenge/
├─ README.md    <<<<<<<<<<<<<<<<<<<<<<<<<< YOU ARE HERE
├─ allData/                              * all data, in various formats
│  ├─ gp/
│  ├─ hospitalisation/
│  ├─ mortality/
│  ├─ swab/
│  ├─ vaccine/
│  └─ ...
├─ bibliography/
│  └─ UKHSA_bibliography.bib
├─ images/
│  └─ ...                                * full-resolution copy of all plots and infographic
├─ Meeting_notes
│  └─ ...
├─ Presentation
│  ├─ images/
│  ├─ Presentation_files/
│  ├─ Presentation.html
│  └─ Presentation.qmd
├─ Presentation_files
│  └─ ...
├─ R_scripts
│  ├─ Season_data/
│  ├─ source/
│  ├─ corr.R
│  ├─ source_data_entry.R
│  └─ web_scraping_all_flu_subtypes.R
├─ report/
│  ├─ images/
│  ├─ UKHSA_report_files/
│  ├─ method_notes.R
│  ├─ UKHSA_report.html
│  ├─ UKHSA_report.pdf                   * the report rendered into pdf
│  └─ UKHSA_report.qmd                   * the report, with editable and executable code
├─ new_folder/
│  ├─ new_folder/
│  ├─ new_folder/
│  └─ new_folder/
├─ data_challenge.Rproj
└─ .gitignore

```

