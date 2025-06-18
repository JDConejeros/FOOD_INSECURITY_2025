# Food insecurity and overcrowding: The concurrence between two social determinants of health in Urban Chilean households 

**Authors**: 
Gabriel González Medina<sup>1</sup>, Leslie Landaeta-Díaz<sup>2,3</sup>, Francisco Vergara-Perucich<sup>4</sup>, José Daniel Conejeros<sup>5,6</sup>

1 Facultad de Medicina. Departamento de Salud Pública, Pontificia Universidad Católica de Chile, Chile. Gagonzalez1@uc.cl https://orcid.org/0000-0001-8241-3076

2 Facultad de Salud y Ciencias Sociales, Universidad de las Américas, Chile. llandaeta@udla.cl https://orcid.org/0000-0001-8970-1150

3 Núcleo de Investigación en Nutrición y Ciencias Alimentarias (NINCAL), Universidad de las Américas, Chile
4Núcleo Centro Producción del Espacio, Universidad de las Américas, Chile. jvergara@udla.cl https://orcid.org/0000-0002-1930-4691

5 Escuela de Gobierno, Pontificia Universidad Católica de Chile, Santiago, Chile.

6 College UC y Escuela de Salud Pública, Pontificia Universidad Católica de Chile, Santiago, Chile.
Autor de correspondencia: Leslie Landaeta-Díaz. Facultad de Salud y Ciencias Sociales. Avenida Walker Martínez 1360, Edificio A. La Florida-Santiago, Chile.


**Abstract**: 
Household overcrowding and food insecurity are closely intertwined markers of socioeconomic hardship that may exacerbate health inequities. Using data from 58,615 urban adults participating in Chile’s 2022 CASEN survey, we measured moderate–severe food insecurity via the eight-item FIES (raw score ≥ 4) and defined overcrowding as persons-per-bedroom ratio categorized into four mutually exclusive levels. Accounting for survey design, we first mapped and described the national distribution of both phenomena, finding overlapping hotspots in the north and metropolitan regions. Multivariable, survey-weighted logistic regression—adjusted for sex, age, Indigenous identity, nationality, employment status, income quintile, multidimensional poverty, and region—revealed that high overcrowding conferred 31% higher odds of food insecurity (OR 1.31; 95% CI 1.04–1.65) compared to no overcrowding. Female sex, foreign nationality, unemployment, and poverty each independently elevated risk, whereas older age and higher income were protective. The co-occurrence and regional clustering of overcrowding and food insecurity underscore the need for integrated housing and food-access policies to address underlying social determinants and mitigate health inequities across Chile. 

## Project Overview
This repository contains the research project on food insecurity for 2025. The project includes data analysis, statistical modeling, and manuscript preparation.

For questions or collaboration inquiries, please contact:
- José Conejeros (Repository Maintainer)
  - Email: [jdconejeros@uc.cl]
  - Institution: [Pontificia Universidad Católica de Chile]

## Repository Structure

### Code
The `Code` directory contains all R scripts for data processing and analysis:
- `0.0 Setup.R`: Package verification and environment setup
- `0.0 Update_renv.R`: Script for updating package environment (developers only)
- `0.1 Settings.R`: Project settings and configurations
- `0.2 Functions.R`: Custom functions used throughout the analysis
- `1.0 Process_data.R`: Data processing and preparation
- `2.0 Descriptives.R`: Descriptive statistics and exploratory analysis
- `3.0 Logit Models.R`: Logistic regression models
- `4.0 Count Models.R`: Count data models

### Paper
The `Paper` directory contains manuscript-related files:
- Manuscript with author details
- Reviewer comments and actions
- LaTeX style files for journal formatting

### Input
Directory containing raw data and input files for the analysis.

### Output
Directory containing generated results, figures, and tables.

## Reproducibility Guide

### System Requirements
- R version 4.0.0 or higher
- RStudio (recommended)
- Git

### Environment Setup

1. **Clone the repository**
   ```bash
   git clone [REPOSITORY_URL]
   cd FOOD_INSECURITY_2025
   ```

2. **Restore the R environment**
   ```R
   # In R or RStudio
   renv::restore()
   ```

3. **Verify the setup**
   ```R
   source("Code/0.0 Setup.R")
   ```

### For Developers

If you are a developer working on this project and need to update the package environment:

1. **Update packages as needed**
   ```R
   # Install or update packages as required
   install.packages("new_package")
   ```

2. **Update the environment snapshot**
   ```R
   source("Code/0.0 Update_renv.R")
   ```

3. **Commit the updated renv.lock**
   ```bash
   git add renv.lock
   git commit -m "Update package environment"
   git push
   ```

### Running the Analysis

1. **Data preparation**
   ```R
   source("Code/1.0 Process_data.R")
   ```

2. **Descriptive analysis**
   ```R
   source("Code/2.0 Descriptives.R")
   ```

3. **Logistic models**
   ```R
   source("Code/3.0 Logit Models.R")
   ```

4. **Count models (poisson and binomial negative)**
   ```R
   source("Code/4.0 Count Models.R")
   ```

### Session Information

Detailed R session information, including package versions and system configuration, is saved in:
```
Output/session_info.rds
```

To view this information:

```R
session_info <- readRDS("Output/session_info.rds")
print(session_info)
```

```
R version 4.5.0 (2025-04-11)
Platform: aarch64-apple-darwin20
Running under: macOS Sequoia 15.4.1

Matrix products: default
BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib 
LAPACK: /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.1

locale:
[1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/es_ES.UTF-8

time zone: America/Santiago
tzcode source: internal

attached base packages:
[1] grid      stats     graphics  grDevices utils     datasets 
[7] methods   base     

other attached packages:
 [1] testthat_3.2.3          roxygen2_7.3.2         
 [3] devtools_2.4.5          usethis_3.1.0          
 [5] ggpubr_0.6.0            ggrepel_0.9.6          
 [7] patchwork_1.3.0         ggridges_0.5.6         
 [9] scales_1.4.0            ggthemes_5.1.0         
[11] chilemapas_0.3.0        sf_1.0-21              
[13] gtsummary_2.2.0         tableone_0.13.2        
[15] kableExtra_1.4.0        rmarkdown_2.29         
[17] knitr_1.50              openxlsx_4.2.8         
[19] ResourceSelection_0.3-6 pROC_1.18.5            
[21] car_3.1-3               carData_3.0-5          
[23] broom_1.0.8             writexl_1.5.4          
[25] srvyr_1.3.0             survey_4.4-2           
[27] survival_3.8-3          Matrix_1.7-3           
[29] haven_2.5.4             rio_1.2.3              
[31] lubridate_1.9.4         forcats_1.0.0          
[33] stringr_1.5.1           dplyr_1.1.4            
[35] purrr_1.0.4             readr_2.1.5            
[37] tidyr_1.3.1             tibble_3.2.1           
[39] ggplot2_3.5.2           tidyverse_2.0.0        

loaded via a namespace (and not attached):
 [1] DBI_1.2.3          remotes_2.5.0      rlang_1.1.6       
 [4] magrittr_2.0.3     rmapshaper_0.5.0   e1071_1.7-16      
 [7] compiler_4.5.0     systemfonts_1.2.3  vctrs_0.6.5       
[10] profvis_0.4.0      pkgconfig_2.0.3    fastmap_1.2.0     
[13] backports_1.5.0    ellipsis_0.3.2     promises_1.3.3    
[16] sessioninfo_1.2.3  tzdb_0.5.0         xfun_0.52         
[19] cachem_1.1.0       jsonlite_2.0.0     later_1.4.2       
[22] R6_2.6.1           stringi_1.8.7      RColorBrewer_1.1-3
[25] pkgload_1.4.0      brio_1.1.5         Rcpp_1.0.14       
[28] R.utils_2.13.0     httpuv_1.6.16      splines_4.5.0     
[31] timechange_0.3.0   tidyselect_1.2.1   rstudioapi_0.17.1 
[34] abind_1.4-8        miniUI_0.1.2       curl_6.2.2        
[37] pkgbuild_1.4.8     lattice_0.22-6     plyr_1.8.9        
[40] shiny_1.10.0       withr_3.0.2        evaluate_1.0.3    
[43] urlchecker_1.0.1   units_0.8-7        proxy_0.4-27      
[46] zip_2.3.3          xml2_1.3.8         pillar_1.10.2     
[49] KernSmooth_2.23-26 renv_1.1.4         generics_0.1.4    
[52] sp_2.2-0           hms_1.1.3          xtable_1.8-4      
[55] class_7.3-23       glue_1.8.0         tools_4.5.0       
[58] data.table_1.17.4  ggsignif_0.6.4     fs_1.6.6          
[61] mitools_2.4        nlme_3.1-168       Formula_1.2-5     
[64] cli_3.6.5          textshaping_1.0.1  viridisLite_0.4.2 
[67] svglite_2.2.1      V8_6.0.3           gtable_0.3.6      
[70] R.methodsS3_1.8.2  rstatix_0.7.2      digest_0.6.37     
[73] classInt_0.4-11    htmlwidgets_1.6.4  farver_2.1.2      
[76] memoise_2.0.1      htmltools_0.5.8.1  R.oo_1.27.1       
[79] lifecycle_1.0.4    mime_0.13    
```

### Troubleshooting

Common issues and solutions:

1. **Package restoration errors**
   ```R
   renv::repair()
   ```

2. **Update packages**
   ```R
   renv::update()
   ```

3. **Clear renv cache**
   ```R
   renv::clean()
   ```

## License
This project is licensed under the terms included in the LICENSE file.

