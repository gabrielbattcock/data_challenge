---
version: 0.1.0
author: GB, AC, SJ, HL
---

# Data_Challenge

## Overview

## How to use this script

### 1. Download

If you have SSH configured, great, just run `git clone git@github.com:gabrielbattcock/data_challenge.git` in your terminal and it'll be sorted.

If you don't, all is not lost my friend, just run `git clone https://github.com/gabrielbattcock/data_challenge.git` in your terminal.

### 2. Dependencies

This project cannot be built without the numerous packages from the R community. We use `pacman::p_load()` to install if needed, and load these packages without user intervention. If you prefer to install these selectively or individually, below is a comprehensive list of the packages, grouped by purpose.

knitr, kableExtra, mada, magrittr, RcppRoll, reshape2, spgwr)

-   GENERAL PURPOSE
    -   [Tidyverse (core)](https://www.tidyverse.org/packages/)
    -   [Magrittr](https://magrittr.tidyverse.org/)
    -   [Knitr](https://cran.r-project.org/web/packages/knitr/index.html)
    -   [Reshape2 (retired)](https://cran.r-project.org/web/packages/reshape2/index.html)
    -   [kableExtra](https://cran.r-project.org/web/packages/kableExtra/index.html)
    -   [mada](https://cran.r-project.org/web/packages/mada/index.html)
-   READING FILES
-   DATA MANIPULATION
    -   [RcppRoll](https://cran.r-project.org/web/packages/RcppRoll/index.html)

### 3. Running the codes

With in the directory "R_scripts", there is a script called

```{r}
source("source_data_entry.R")

```

"source_data_entry.R" which inputs all data from the various csv and xlsx files that we have collected and outputs data frames which are used throughout the rest of the project.

The remainder of the code are saved under either "Season_data", for plots and analysis comparing each source over a season or in "source", which compares the seasons for a given source, such as GP data. Once "source_data_entry.R" has been run and all data frames are within your environment, all other scripts should run.
