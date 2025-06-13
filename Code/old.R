run_count_models <- function(data, outcome, exposure,
  id = "varunit", strata = "varstrat", weight = "expc") {

# Form
formula <- as.formula(paste(outcome, "~", exposure, "+", paste(covariates, collapse = "+")))

# Complex desing
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

list(
poisson = broom::tidy(model_pois, conf.int = TRUE, conf.level = 0.95, exponentiate = TRUE) |>
filter(term != "(Intercept)") |>
rename(IRR = estimate, CI_low = conf.low, CI_high = conf.high),

negbin = broom::tidy(model_nb, conf.int = TRUE, conf.level = 0.95, exponentiate = TRUE) |>
filter(term != "(Intercept)") |>
rename(IRR = estimate, CI_low = conf.low, CI_high = conf.high),

zinb = broom::tidy(model_zinb, conf.int = TRUE, conf.level = 0.95, exponentiate = TRUE) |>
filter(term != "(Intercept)") |>
rename(IRR = estimate, CI_low = conf.low, CI_high = conf.high)
)
}
