# Code 3: Logit Models ----

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

## Models FI ---- 

# Explorer outcomes
# Dummies
table(casen22$food_ins1)
table(casen22$food_insecurity_binary)

# Explorer var independents 
# Dummy
table(casen22$ind_overcrowding_binary)
table(casen22$overcrowded)

# Multicat
table(casen22$ind_overcrowding)

# Numeric
table(casen22$overcrowding)
hist(log(casen22$overcrowding))

casen22 <- casen22 |> 
  mutate(overcrowding_log = log(overcrowding))

### Models outcome Dummy -----

# Outcomes binarios
outcomes <- c("food_insecurity_binary", "food_ins1")

# Variables de exposición (hacinamiento)
exposures <- c("ind_overcrowding_binary", 
               "overcrowded", 
               "ind_overcrowding", 
               "overcrowding", 
               "overcrowding_log")
# Covariates
covariates <- c("sex", "age_group", "ethnic", "nac", "job", "qaut",
                "zone", "multi_poverty", "reg")

#### Weight Model ----
fit_logistic_tidy <- function(data, outcome, exposure, weight_var) {
  
  # Construir fórmula
  fmla <- as.formula(paste(outcome, "~", exposure, "+", paste(covariates, collapse = "+")))
  
  # Ajustar modelo glm con pesos
  model <- glm(fmla, data = data, family = binomial(link = "logit"), 
               weights = data[[deparse(substitute(weight_var))]])
  
  # Extraer resumen con OR directamente
  broom::tidy(model, conf.int = TRUE, conf.level = 0.95, exponentiate = TRUE) |>
    filter(term != "(Intercept)") |>
    select(term, estimate, std.error, conf.low, conf.high, p.value) |>
    rename(
      OR = estimate,
      CI_low = conf.low,
      CI_high = conf.high
    )
}

model_list <- list()

# Iterations models 
for (y in outcomes) {
  for (x in exposures) {
    # Name models
    model_name <- paste0("log_", y, "_~_", x)
    
    # Adjuts models
    model_list[[model_name]] <- fit_logistic_tidy(
      data       = casen22,
      outcome    = y,
      exposure   = x,
      weight_var = expc
    )
  }
}

# Save results
model_list 
names(model_list) <- gsub("~", "", names(model_list))
write_xlsx(model_list, path = "Output/Logit_models_weight.xlsx")

####  With complex desing model ----

run_logistic_model <- function(data, outcome, exposure,
                               id = "varunit", strata = "varstrat", weight = "expc") {
  
  # Diseño complejo
  svy_design <- svydesign(
    ids = as.formula(paste0("~", id)),
    strata = as.formula(paste0("~", strata)),
    weights = as.formula(paste0("~", weight)),
    data = data,
    nest = TRUE
  )
  
  # Fórmula
  formula <- as.formula(paste(outcome, "~", exposure, "+", paste(covariates, collapse = "+")))
  
  # Modelo
  model <- svyglm(formula, design = svy_design, family = quasibinomial())
  
  # Resultado tidy + OR manual
  tidy(model, conf.int = TRUE, conf.level = 0.95,  exponentiate = TRUE) |>
    filter(term != "(Intercept)") |>
    mutate(
      OR      = exp(estimate),
      CI_low  = exp(conf.low),
      CI_high = exp(conf.high)
    ) |>
    select(term, estimate, std.error, OR, CI_low, CI_high, p.value)
}

# Lista para guardar modelos
model_list_svy <- list()

# Iterations models 
for (y in outcomes) {
  for (x in exposures) {
    model_name <- paste0("svy_", y, "_~_", x)
    
    model_list_svy[[model_name]] <- run_logistic_model(
      data    = casen22,
      outcome = y,
      exposure = x,
      id      = "varunit",
      strata  = "varstrat",
      weight  = "expc"
    )
  }
}

# Save results
model_list_svy
names(model_list_svy) <- gsub("~", "", names(model_list_svy))
write_xlsx(model_list_svy, path = "Output/Logit_models_svy.xlsx")

