# Code 2: Descriptives Analysis ----

## Settings ----
source("Code/0.1 Settings.R")
source("Code/0.2 Functions.R")
source("Code/0.3 Packages.R")

# Data path 
data_inp <- "Input/"
data_out <- "Output/"

## Open data ---- 

casen22 <- rio::import(paste0(data_inp, "casen_2022_process", ".RData"))
glimpse(casen22)

# Outcomes
outcomes <- c("food_insecurity_binary", "food_ins1", "food_insecurity_score")

# Variables de exposición (hacinamiento)
exposures <- c("ind_overcrowding_binary", 
               "overcrowded", 
               "ind_overcrowding", 
               "overcrowding")
# Covariates
covariates <- c("sex", "age_group", "ethnic", "nac", "job", "qaut",
                "zone", "multi_poverty", "reg")

casen22 <- casen22 |> 
  dplyr::select(all_of(c(outcomes, exposures, covariates)))

glimpse(casen22)

## Descriptives ----

data_des <- casen22 |> 
  mutate(
    sex                      = as_factor(sex),
    food_insecurity_binary   = factor(food_insecurity_binary, levels = c(0, 1), labels = c("No", "Yes")),
    food_ins1                = factor(food_ins1, levels = c(0, 1), labels = c("No", "Yes")),
    ind_overcrowding_binary  = factor(ind_overcrowding_binary, levels = c(0, 1), labels = c("No", "Yes")),
    overcrowded              = factor(overcrowded, levels = c(0, 1), labels = c("No", "Yes")),
    ind_overcrowding         = as_factor(ind_overcrowding),
    age_group                = as_factor(age_group),
    ethnic                   = as_factor(ethnic),
    nac                      = as_factor(nac),
    job                      = as_factor(job),
    qaut                     = as_factor(qaut),
    zone                     = as_factor(zone),
    multi_poverty            = as_factor(multi_poverty),
    reg                      = as_factor(reg)
  )

  label_list <- list(
    food_insecurity_score    ~ "Food Insecurity Score",
    food_insecurity_binary   ~ "FI: Moderate or Severe",
    food_ins1                ~ "FI: Any Level",
    overcrowding             ~ "Overcrowding (continuous)",
    ind_overcrowding_binary  ~ "FI: Binary Indicator of Overcrowding",
    overcrowded              ~ "Severely Overcrowded (Binary)",
    ind_overcrowding         ~ "Overcrowding Categories (PPB)",
    age_group                ~ "Age Group",
    ethnic                   ~ "Ethnic Identity",
    nac                      ~ "Nationality",
    job                      ~ "Employment Status",
    qaut                     ~ "Quintile Income",
    zone                     ~ "Urban/Rural",
    multi_poverty            ~ "Multidimensional Poverty",
    reg                      ~ "Region"
  )
  

data_des |> 
  dplyr::select(
    sex,
    food_insecurity_score,
    food_insecurity_binary,
    food_ins1,
    overcrowding,
    ind_overcrowding_binary,
    overcrowded,
    ind_overcrowding,
    all_of(covariates)
  ) %>%
  tbl_summary(
    by = sex,
    missing = "no",
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    type = list(
      food_insecurity_score ~ "continuous",
      overcrowding ~ "continuous"
    ),
    label = label_list
  ) %>%
  add_p(test = all_continuous() ~ "wilcox.test") %>%
  add_overall() %>%
  modify_header(label = "**Variable**") %>%
  modify_spanning_header(starts_with("stat_") ~ "**Sex**") %>%
  bold_labels()

## FI VS Overcrowding ----

### Tables -----
label_list <- list(
  #food_insecurity_binary ~ "FI Moderate or Severe",
  #food_insecurity_score ~ "Food Insecurity Score",
  #food_ins1 ~ "FI Any Level (Score ≥ 1)",
  overcrowding ~ "Overcrowding (People per Bedroom)",
  ind_overcrowding_binary ~ "Critical Overcrowding (Binary)",
  overcrowded ~ "Overcrowded Household (Binary)",
  ind_overcrowding ~ "Overcrowding Level (Categorical)"
)

data |>
  dplyr::select(
    food_insecurity_binary,
    #food_insecurity_score,
    #food_ins1,
    overcrowding,
    ind_overcrowding_binary,
    overcrowded,
    ind_overcrowding
  ) %>%
  tbl_summary(
    by = food_insecurity_binary,
    missing = "no",
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    type = list(
      #food_insecurity_score ~ "continuous",
      overcrowding ~ "continuous"
    ), 
    label = label_list
  ) %>%
  add_p(test = all_continuous() ~ "wilcox.test") %>%
  add_overall() %>%
  modify_header(label = "**Variable**") %>%
  modify_spanning_header(starts_with("stat_") ~ "**FI Moderate/Severe**") %>%
  bold_labels()

casen22 |>
  dplyr::select(
    food_ins1,
    #food_insecurity_score,
    #food_insecurity_binary,
    overcrowding,
    ind_overcrowding_binary,
    overcrowded,
    ind_overcrowding
  ) %>%
  tbl_summary(
    by = food_ins1,
    missing = "no",
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    type = list(
      #food_insecurity_score ~ "continuous",
      overcrowding ~ "continuous"
    ),
    label = label_list
  ) %>%
  add_p(test = all_continuous() ~ "wilcox.test") %>%
  add_overall() %>%
  modify_header(label = "**Variable**") %>%
  modify_spanning_header(starts_with("stat_") ~ "**FI Any Level**") %>%
  bold_labels()


### Figures -----




### Map -----

