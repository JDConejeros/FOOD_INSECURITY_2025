# Code 2: Descriptives Analysis ----

## Settings ----
source("Code/0.1 Settings.R")
source("Code/0.2 Functions.R")
source("Code/0.3 Packages.R")

# Data path 
data_inp <- "Input/"
data_out <- "Output/"

## Open data ---- 

data <- rio::import(paste0(data_inp, "casen_2022_process", ".RData"))
glimpse(data)