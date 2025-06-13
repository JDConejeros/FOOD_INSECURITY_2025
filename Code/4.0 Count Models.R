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
# Numeric
table(casen22$food_insecurity_score)
hist(casen22$food_insecurity_score)

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

### Models outcome Count -----

# Outcomes binarios
outcomes <- c("food_insecurity_score")

# Variables de exposición (hacinamiento)
exposures <- c("ind_overcrowding_binary", 
               "overcrowded", 
               "ind_overcrowding", 
               "overcrowding", 
               "overcrowding_log")
# Covariates
covariates <- c("sex", "age_group", "ethnic", "nac", "job", "qaut",
                "zone", "multi_poverty", "reg")

run_count_models <- function(data, outcome, exposure,
                             id = "varunit", strata = "varstrat", weight = "expc") {
  
  formula <- as.formula(paste(outcome, "~", exposure, "+", paste(covariates, collapse = "+")))
  
  svy_design <- svydesign(
    ids = as.formula(paste0("~", id)),
    strata = as.formula(paste0("~", strata)),
    weights = as.formula(paste0("~", weight)),
    data = data,
    nest = TRUE
  )
  
  # Poisson
  model_pois <- svyglm(formula, design = svy_design, family = quasipoisson())
  
  # Negative binomial
  model_nb <- glm.nb(formula, data = data, weights = data[[weight]])
  
  # Zero-inflated NB
  model_zinb <- zeroinfl(formula, data = data, dist = "negbin", weights = data[[weight]])
  
  # Extraer coeficientes manually del count part (no zero-part)
  zinb_summary <- summary(model_zinb)
  zinb_coef <- coef(zinb_summary)$count
  zinb_df <- as.data.frame(zinb_coef)
  zinb_df$term <- rownames(zinb_df)
  rownames(zinb_df) <- NULL
  
  zinb_df <- zinb_df |>
    filter(term != "(Intercept)") |>
    mutate(
      IRR = exp(Estimate),
      CI_low = exp(Estimate - 1.96 * `Std. Error`),
      CI_high = exp(Estimate + 1.96 * `Std. Error`)
    ) |>
    rename(
      estimate = Estimate,
      std.error = `Std. Error`,
      p.value = `Pr(>|z|)`
    ) |>
    select(term, estimate, std.error, IRR, CI_low, CI_high, p.value)
  
  list(
    poisson = broom::tidy(model_pois, conf.int = TRUE, conf.level = 0.95, exponentiate = TRUE) |>
      filter(term != "(Intercept)") |>
      rename(IRR = estimate, CI_low = conf.low, CI_high = conf.high),
    
    negbin = broom::tidy(model_nb, conf.int = TRUE, conf.level = 0.95, exponentiate = TRUE) |>
      filter(term != "(Intercept)") |>
      rename(IRR = estimate, CI_low = conf.low, CI_high = conf.high),
    
    zinb = zinb_df
  )
}

# List
poisson_models <- list()
negbin_models  <- list()
zinb_models    <- list()

# Iterations
for (y in outcomes) {
  for (x in exposures) {
    model_name <- paste0(y, "_vs_", x)
    
    result <- run_count_models(
      data    = casen22,
      outcome = y,
      exposure = x,
      id      = "varunit",
      strata  = "varstrat",
      weight  = "expc"
    )
    
    poisson_models[[model_name]] <- result$poisson
    negbin_models[[model_name]]  <- result$negbin
    zinb_models[[model_name]]    <- result$zinb
  }
}

# Save models
poisson_models
negbin_models
zinb_models

write_xlsx(poisson_models, path = "Output/Count_Poisson_models_svy.xlsx")
write_xlsx(negbin_models,  path = "Output/Count_Negbin_models_svy.xlsx")
write_xlsx(zinb_models,    path = "Output/Count_ZINB_models_svy.xlsx")


