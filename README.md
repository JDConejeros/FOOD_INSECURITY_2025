# Food insecurity and overcrowding: The concurrence between two social determinants of health in Urban Chilean households 

**Authors**: 
Gabriel González Medina$^1$, Leslie Landaeta-Díaz$^{2,3}$, Francisco Vergara-Perucich$^4$, José Daniel Conejeros$^{5,6}$

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

