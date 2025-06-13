# Packages ---- 

# Function install/load packages
install_load <- function(packages){
  for (i in packages) {
    if (i %in% rownames(installed.packages())) {
      library(i, character.only=TRUE)
    } else {
      install.packages(i)
      library(i, character.only = TRUE)
    }
  }
}

# Apply function
install_load(c("rio", 
               "janitor", 
               "tidyverse", 
               "openxlsx",
               "chilemapas", 
               "patchwork",
               "sf", 
               "vtable", 
               "parallel", 
               "profvis", 
               "future", 
               "purrr", 
               "furrr",
               "future.apply", 
               "zoo",     
               "magrittr",    
               "ggstatsplot",
               "knitr", 
               "kableExtra",
               "writexl",
               "RColorBrewer",
               "ggpubr",
               "GGally",
               "yardstick",
               "doParallel", 
               "beepr",
               "tictoc",
               "paletteer",
               "texreg",
               "tidymodels", 
               "broom",
               "psych",
               "survey",
               "gtsummary",
               "ggridges",
               "tableone",
               "MASS",
               "pscl"
               ))


