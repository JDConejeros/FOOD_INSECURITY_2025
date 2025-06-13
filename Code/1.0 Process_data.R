# Code 1: Data process ----

## Settings ----
source("Code/0.1 Settings.R")
source("Code/0.2 Functions.R")
source("Code/0.3 Packages.R")

# Data path 
data_inp <- "Input/"

## Open data ---- 

# CASEN: Encuesta de caracterización socioeconómica
# National survey of characterization socioeconomic (CHILE)
casen <- rio::import(paste0(data_inp, "Base de datos Casen 2022 STATA", ".dta")) 
casen_com <- rio::import(paste0(data_inp, "Base de datos provincia y comuna Casen 2022 STATA", ".dta")) 

glimpse(casen)
glimpse(casen_com)

## Edit covariates ---- 

casen <- casen |> 
  mutate(
    sex = factor(sexo, levels = c(1,2), labels = c("Man", "Woman") ), # Sex
    age = as.numeric(edad), # Age
    se = as.factor(nse), # Socioeconomic level
    qaut = as.factor(qaut), # Income quantile
    reg = as.factor(region), # Region
    area = as.factor(area), # area
    tot_per_h = as.numeric(tot_per_h), # Total people in home 
    numper = as.numeric(numper) # Total people in home (without domestic service)
  ) |> 
  mutate(age_group = case_when(
    age >= 18 & age <= 24 ~ "18-24",     # MINSAL threshold based
    age >= 25 & age <= 44 ~ "25-44",
    age >= 45 & age <= 64 ~ "45-64",
    age >= 65 ~ "65+"
  ))

## Principal Predictor: Overcrowding ---- 

casen <- casen|>
  mutate(
    # Number of households in the dwelling
    nhom_viv = case_when(
      p9 == 1 ~ 1,
      p10 == 1 ~ 1,
      p10 == 2 ~ p11,
      TRUE ~ NA_real_
    ),
    
    # Number of bedrooms in the dwelling
    ndor_viv = v27a,
    
    # Number of bedrooms occupied by the household
    ndor_hog = v29a,
    
    # Overcrowding calculation
    overcrowding = case_when(
      nhom_viv == 1 & ndor_viv > 0 & ndor_viv < 99 ~ numper / ndor_viv,
      nhom_viv == 1 & ndor_viv == 0 ~ 8888,
      nhom_viv == 1 & (ndor_viv == 99 | ndor_viv == -88) ~ 9999,
      nhom_viv > 1 & ndor_hog > 0 & ndor_hog < 99 ~ numper / ndor_hog,
      nhom_viv > 1 & (ndor_hog == 99 | ndor_hog == -88) ~ 9999,
      nhom_viv > 1 & ndor_hog == 0 ~ 8888,
      TRUE ~ NA_real_
    ),
    
    # Overcrowding index
    ind_overcrowding = case_when(
      overcrowding >= 0 & overcrowding < 2.5 ~ 1,
      overcrowding >= 2.5 & overcrowding < 3.5 ~ 2,
      overcrowding >= 3.5 & overcrowding < 5 ~ 3,
      overcrowding >= 5 & overcrowding <= 8888 ~ 4,
      overcrowding == 9999 ~ 99,
      TRUE ~ NA_real_
    )
  )

# Define labels 
ind_over_labels <- c(
    "1" = "No overcrowding (<2.5 PPB)",
    "2" = "Medium overcrowding (2.5 to 3.49 PPB)",
    "3" = "High overcrowding (3.5 to 4.99  PPB)",
    "4" = "Critical overcrowding (>=5 PPB)",
    "99" = "No data (dk/na in number of exclusive use bedrooms)"
  )

casen <- casen |> 
  mutate(ind_overcrowding = factor(ind_overcrowding, 
                                   labels = ind_over_labels)) |> 
  # Dummy overcrowding
  mutate(ind_overcrowding_binary = case_when(
    as.numeric(ind_overcrowding) < 2 ~ 0,
    as.numeric(ind_overcrowding) > 1 & as.numeric(ind_overcrowding) < 5 ~ 1,
    TRUE ~ NA_real_
  ))

## Size house ---- 

casen <- casen |>
  mutate(
      sh = case_when(
      v12 == -88 ~ NA_character_,
      v12 == 1 ~ "Less than 30 m2",
      v12 == 2 ~ "30 to 40 m2",
      v12 == 3 ~ "41 to 60 m2",
      v12 == 4 ~ "61 to 100 m2",
      v12 == 5 ~ "101 to 150 m2",
      v12 == 6 ~ "More than 150 m2"
    )
  )|> 
  mutate(sh = factor(sh, levels = c("Less than 30 m2",
                                       "30 to 40 m2",
                                       "41 to 60 m2",
                                       "61 to 100 m2",
                                       "101 to 150 m2",
                                       "More than 150 m2")))

casen <- casen |>
  mutate(
  overcrowded = case_when(
    sh == "Less than 30 m2" & overcrowding > 1.5 ~ 1,   # Overcrowded if > 1.5 for < 30 m²
    sh %in% c("30 to 40 m2", "41 to 60 m2") & overcrowding > 2.0 ~ 1,  # Overcrowded if > 2 for 30-60 m²
    sh %in% c("61 to 100 m2", "101 to 150 m2", "More than 150 m2") & overcrowding > 2.5 ~ 1, # Overcrowded if > 2.5 for > 60 m²
    TRUE ~ 0  # Not overcrowded
  ))

# Check 
table_comparison <- table(casen$ind_overcrowding_binary, casen$overcrowded)

dimnames(table_comparison) <- list(
  "Without Size Adjustment" = c("No Overcrowding", "Overcrowded"),
  "With Size Adjustment" = c("No Overcrowding", "Overcrowded")
)
table_comparison

# Calculate agreement and disagreement rates
agreement_rate <- sum(diag(table_comparison)) / sum(table_comparison)
disagreement_rate <- 1 - agreement_rate

paste0("Agreement Rate: ", round(agreement_rate * 100, 2), "%")
paste0("Disagreement Rate: ", round(disagreement_rate * 100, 2), "%")

## Food insecurity Raw Scores ----

casen <- casen |>
  mutate(
    across(r8a:r8h, ~ case_when(
      . == 1 ~ 1,
      . == 2 ~ 0,
      TRUE ~ .
    )),
    food_insecurity_score = rowSums(across(r8a:r8h), na.rm = TRUE)
  )

alpha(casen[, c("r8a", "r8b", "r8c", "r8d", "r8e", "r8f", "r8g", "r8h")]) # 0.87

## Select sample ----

# Urban areas

casen <- casen |> 
  filter(edad > 17 & id_persona==1 & pco1_a  == 1 & overcrowding <1000 & v12 != -88) |> 
droplevels() # Regional representative

# Add municipality data
casen_full <- casen |> left_join(casen_com, by = c("folio", "id_persona"))

#casen_full <- casen_full |> filter(area == 1) # Urban areas
glimpse(casen_full)

## Final adjust -----

# Edit variables 
casen_full <- casen_full |> 
  mutate(food_insecurity_binary = ifelse(food_insecurity_score >= 4, 1, 0)) |> 
  mutate(se = factor(se, 
                    levels = 1:7,
                    labels = c("Low", "Medium", "High", 
                                "Low-Medium", "Low-High", "Low-Medium-High", 
                                "Medium-High"))) |> 
  rename(mun = comuna) |> 
  mutate(food_ins1 = if_else(r8a == 1, 1, 0)) |> 
  mutate(income_poverty = case_when(
                                  pobreza==1 ~ 1,
                                  pobreza==2 ~ 1,
                                  pobreza==3 ~ 0,
                                  TRUE ~ NA
                                ),
                                  ) |> 
  mutate(income_poverty = factor(pobreza, 
                                 levels = c(0,1),
                                 labels = c("No Poverty", "Poverty")
                                )) |> 
  mutate(multi_poverty = factor(pobreza_multi_5d,
                                levels = c(0,1),
                                labels = c("No Poverty", "Poverty")
                              )) |> 
  mutate(zone = 2-as.numeric(area)) |> 
  mutate(zone = factor(zone, 
                       levels=c(0,1),
                       labels=c("Rural", "Urbano")
                      )) |> 
  mutate(job = factor(activ, 
                      levels=c(1:3),
                      labels=c("Employed", "Unemployed", "Not in the labor force")
  )) |> 
  mutate(ethnic = if_else(
    r3==11, 1, 0
  )) |> 
  mutate(ethnic = factor(ethnic, 
                        levels = c(0,1), 
                        labels = c("No", "Yes")
                        )) |> 
  mutate(nac = case_when(
    r1a %in% c(1, 2) ~ 0,
    r1a == 3 ~ 1,
    TRUE ~ NA_real_  
  )) |> 
  mutate(nac = factor(nac, levels = c(0, 1), labels = c("Native", "Foreign")))

casen_full <- casen_full |> 
  select(
  # Spatial and ID
  "folio", "id_persona", "reg", "mun", "zone",

  # Survey design
  "varunit", "varstrat", "expr", "expc",

  # Socioeconomic and demographic
  "sex", "age", "age_group", "ethnic", "nac", "job", "se", "qaut", "reg", "area", "tot_per_h", "numper",
  "income_poverty", "multi_poverty", "ypch",
  
  # Overcrowding
  "p9", "p10", "p11", "v27a", "v29a", "v12", "nhom_viv", "ndor_viv", "ndor_hog", "overcrowding",
  "ind_overcrowding", "ind_overcrowding_binary", "overcrowded",
  
  # Food insecurity
  "r8a", "r8b", "r8c", "r8d", "r8e", "r8f", "r8g", "r8h",
  "food_insecurity_score", "food_insecurity_binary", "food_ins1",
  
  # Discrimination
  "r9a", "r9b", "r9c", "r9d", "r9e", "r9o",
  )

# Save data ---------
glimpse(casen_full)
save(casen_full, file=paste0(data_inp, "casen_2022_process", ".RData"))
