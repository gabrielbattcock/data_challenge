---
version: 0.2.0
author: GB, AC, SJ, HL
---

# Data_Challenge

## Overview

## How to use this script

### 1. Download

If you have SSH configured, great, just `cd ~/YOUR/PATH` and run 
`git clone git@github.com:gabrielbattcock/data_challenge.git`
in your terminal and it'll be sorted.

If you don't, all is not lost my friend, you still need to `cd ~/YOUR/PATH` and run 
`git clone https://github.com/gabrielbattcock/data_challenge.git`
in your terminal.

### 2. Dependencies

This project cannot be built without the numerous packages from the R community. We use `pacman::p_load()` to install if needed, and load these packages without user intervention. If you prefer to install these selectively or individually, below is a comprehensive list of the packages, grouped by purpose.

- **GENERAL PURPOSE**
  - [Tidyverse (core)](https://www.tidyverse.org/packages/)
  - [pacman](https://cran.r-project.org/web/packages/pacman/index.html) for loading and installing packages
  - [Magrittr](https://magrittr.tidyverse.org/) for the almighty double pipe `%<>%`
  - [Knitr](https://cran.r-project.org/web/packages/knitr/index.html) for dynamic report generation
  - [kableExtra](https://cran.r-project.org/web/packages/kableExtra/index.html) to construct complex tables within the pipe syntax
  - [mada](https://cran.r-project.org/web/packages/mada/index.html) for metą-analysis of diagnostic accuracy
- **READING FILES**
  - [curl](https://cran.r-project.org/web/packages/curl/index.html) for downloading files
  - [here](https://cran.r-project.org/web/packages/here/index.html) for locating files relative to project root path
  - [openxlsx](https://cran.r-project.org/web/packages/openxlsx/index.html) for reading MS Excel `.xlsx` with the option to fill in merged cells
  - [readxl](https://cran.r-project.org/web/packages/openxlsx/index.html) for reading MS Excel .`xls` (legacy) and `.xlsx`
  - [readODS](https://cran.r-project.org/web/packages/readODS/index.html) for reading OpenDocument Spreadsheet `.ods` into R as data frame
- **DATA MANIPULATION**
  - [Reshape2 \[retired]](https://cran.r-project.org/web/packages/reshape2/index.html) for `melt()`
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
### 3. Running the codes

**You don't need to run `source_data_entry.R` by itself. Open the script you need and it already includes a `source()` in the first few lines.**

With in the directory `../R_scripts`, there is a script called `source_data_entry.R` which gathers the various files in `../allData` that we have collected and outputs data frames which are used throughout the rest of the project. 

The remainder of the code are saved under folders named by their purpose. Refer to `../R_scripts/Season_data` for plots and analysis comparing each source over a season or in `../R_scripts/source`, which compares the seasons for a given source, such as GP data. 

### 4. the quick brown fox jumps over the lazy dog

Bacon ipsum dolor amet boudin ham buffalo, bresaola meatball tri-tip ground round.  Boudin pork belly cupim, corned beef meatball burgdoggen pig filet mignon.  Spare ribs kevin jerky tri-tip alcatra bresaola.  Tongue meatloaf pork belly corned beef swine short ribs short loin pork loin turducken burgdoggen.  Frankfurter sirloin spare ribs turkey short ribs strip steak pork loin porchetta chicken meatball doner bacon venison.
