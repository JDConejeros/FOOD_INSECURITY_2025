# Code 2: Descriptives Analysis ----

## Settings ----
source("Code/0.1 Settings.R")
source("Code/0.2 Functions.R")

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

data_des <- casen22 |> 
  dplyr::select(all_of(c(outcomes, exposures, covariates)))

glimpse(casen22)

## Descriptives ----

data_des <- data_des |> 
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
    ind_overcrowding_binary  ~ "Binary Indicator of Overcrowding",
    overcrowded              ~ "Binary Indicator of Severely Overcrowded",
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
    overcrowding, # Continuo
    ind_overcrowding_binary, # Any level 
    overcrowded, # Severity
    ind_overcrowding, # Multicategories
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
  ind_overcrowding_binary  ~ "Binary Indicator of Overcrowding",
  overcrowded              ~ "Binary Indicator of Severely Overcrowded",
  ind_overcrowding ~ "Overcrowding Level (Categorical)"
)

data_des |>
  dplyr::select(
    food_insecurity_binary,
    #food_insecurity_score,
    #food_ins1,
    overcrowding,
    ind_overcrowding_binary,
    overcrowded,
    ind_overcrowding
  )  |>
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

data_des |>
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

# Prevalence com 

design <- svydesign(
  id = ~varunit,          
  strata = ~varstrat,     
  weights = ~expc,        
  data = casen22              
)

# Estimate prevalence by region
food_insecurity_prev <- svyby(
  ~food_insecurity_binary,
  ~mun,              
  design = design,
  svymean,
  vartype = c("se", "ci")
)

# View results
t1 <- food_insecurity_prev %>%
  as.data.frame() %>%
  mutate(
    prevalence_if = food_insecurity_binary * 100,  
    se = se * 100,
    ci_lower = ci_l * 100,
    ci_upper = ci_u * 100
  ) %>%
  select(mun, prevalence_if)

# Estimate prevalence by region
overcrowding_prev <- svyby(
  ~ind_overcrowding_binary,
  ~mun,
  design = design,
  svymean,
  vartype = c("se", "ci")
)

# Format results as percentages
t2 <- overcrowding_prev %>%
  as.data.frame() %>%
  mutate(
    prevalence_oc = ind_overcrowding_binary* 100,
    se = se * 100,
    ci_lower = ci_l * 100,
    ci_upper = ci_u * 100
  ) %>%
  select(mun, prevalence_oc)

table_data <- t1 |> 
  left_join(t2, by="mun")

com <- chilemapas::codigos_territoriales |> 
  mutate(nombre_comuna=stringr::str_to_title(nombre_comuna)) |> 
  mutate(codigo_comuna=as.numeric(codigo_comuna)) |> 
  mutate(codigo_provincia=as.numeric(codigo_provincia)) |> 
  mutate(codigo_region=as.numeric(codigo_region)) |> 
  rename(name_com="nombre_comuna")

mapa_comunas <- chilemapas::mapa_comunas |> 
  mutate(codigo_comuna=as.numeric(codigo_comuna)) |> 
  mutate(codigo_provincia=as.numeric(codigo_provincia)) |> 
  mutate(codigo_region=as.numeric(codigo_region)) 

com <- com |> 
  left_join(mapa_comunas, by=c("codigo_region", "codigo_provincia", "codigo_comuna"))

table_fig <- com |> 
  left_join(table_data, by=c("codigo_comuna"="mun"))

table_fig <- table_fig |> 
  mutate(macro = factor(
    case_when(
    codigo_region %in% c(1, 2, 3, 15)  ~ "North",
    codigo_region %in% c(4, 5, 13)  ~ "Central",
    codigo_region %in% c(6, 7, 8, 16)  ~ "South Central",
    codigo_region %in% c(9, 10, 14)  ~ "South",
    codigo_region %in% c(11, 12)  ~ "Austral",
    TRUE ~ NA_character_
    ), 
    levels = c("North", "Central", "South Central", "South", "Austral")
  ))

glimpse(table_fig)


# Prevalence reg

design <- svydesign(
  id = ~varunit,          
  strata = ~varstrat,     
  weights = ~expr,        
  data = casen22              
)

# Estimate prevalence by region
food_insecurity_prev <- svyby(
  ~food_insecurity_binary,
  ~reg,              
  design = design,
  svymean,
  vartype = c("se", "ci")
)

# View results
t1 <- food_insecurity_prev %>%
  as.data.frame() %>%
  mutate(
    prevalence_if = food_insecurity_binary * 100,  
    se = se * 100,
    ci_lower = ci_l * 100,
    ci_upper = ci_u * 100
  ) %>%
  select(reg, prevalence_if)

# Estimate prevalence by region
overcrowding_prev <- svyby(
  ~ind_overcrowding_binary,
  ~reg,
  design = design,
  svymean,
  vartype = c("se", "ci")
)

# Format results as percentages
t2 <- overcrowding_prev %>%
  as.data.frame() %>%
  mutate(
    prevalence_oc = ind_overcrowding_binary* 100,
    se = se * 100,
    ci_lower = ci_l * 100,
    ci_upper = ci_u * 100
  ) %>%
  select(reg, prevalence_oc)

table_data <- t1 |> 
  left_join(t2, by="reg")

table_fig_reg <- table_data |> 
  mutate(codigo_region = as.integer(str_extract(reg, "^\\d+"))) |> 
  left_join(com, by=c("codigo_region"), multiple="first") |> 
  mutate(macro = factor(
    case_when(
    codigo_region %in% c(1, 2, 3, 15)  ~ "North",
    codigo_region %in% c(4, 5, 13)  ~ "Central",
    codigo_region %in% c(6, 7, 8, 16)  ~ "South Central",
    codigo_region %in% c(9, 10, 14)  ~ "South",
    codigo_region %in% c(11, 12)  ~ "Austral",
    TRUE ~ NA_character_
    ), 
    levels = c("North", "Central", "South Central", "South", "Austral")
  ))

glimpse(table_fig_reg)

#### Scatter -----

cor.test(table_fig_reg$prevalence_if, table_fig_reg$prevalence_oc, method = "spearman")

zone_colors <- c(
  "North" = "#E41A1C",         # Red
  "Central" = "#FF7F00",       # Orange 
  "South Central" = "#4DAF4A", # Green
  "South" = "#377EB8",         # Blue
  "Austral" = "#984EA3"        # Purple
)

g1 <- table_fig_reg |> 
  ggplot(aes(x = prevalence_oc, y = prevalence_if, color = macro)) +
  geom_point(size = 1.5) + 
  geom_text_repel(aes(label = nombre_region), size = 3, max.overlaps = Inf, show.legend = FALSE) +
  geom_abline(intercept = 3.1, slope = 2.45, linetype = "dashed", color = "gray40") +
  #scale_x_continuous(limits = c(0, 10)) +
  #scale_y_continuous(limits = c(0, 30)) +
  labs(
    x = "Overcrowding Prevalence (%)",
    y = "Food Insecurity Prevalence (%)", 
    title = "A.") +
  scale_color_manual(values = zone_colors) +
  theme_light() +
  theme(
    legend.position = "top",
    legend.text = element_text(size = 10),
    legend.title = element_blank()
  )

#### Distribution -----

g2 <- ggplot(casen22, 
  aes(x = food_insecurity_score, 
      color = ind_overcrowding, 
      fill  = ind_overcrowding)) +
geom_density(alpha = 0.4,           # transparencia para ver overlaps
          bw = 1, 
          size  = 0.5,           # grosor de línea
          position = "identity") +
facet_wrap(~ sex, scales = "free") +                 # una faceta por sexo
scale_fill_manual(
values = c(
 "No overcrowding (<2.5 PPB)"           = "#fce93d",
 "Medium overcrowding (2.5 to 3.49 PPB)" = "#1b9e77",
 "High overcrowding (3.5 to 4.99  PPB)"  = "#4575b4",
 "Critical overcrowding (>=5 PPB)"       = "#542788"
)
) +
scale_color_manual(                    # igual los contornos
values = c(
 "No overcrowding (<2.5 PPB)"           = "#b59500",
 "Medium overcrowding (2.5 to 3.49 PPB)" = "#147951",
 "High overcrowding (3.5 to 4.99  PPB)"  = "#264e7d",
 "Critical overcrowding (>=5 PPB)"       = "#321354"
)
) +
labs(
x     = "Food Insecurity Score",
y     = "Density",
fill  = "Overcrowding level",
color = "Overcrowding level",
title = "B."
) +
guides(
    fill  = guide_legend(nrow = 2, byrow = TRUE),
    color = guide_legend(nrow = 2, byrow = TRUE)
  ) +
theme_light() +
theme(
panel.grid.major = element_blank(),
panel.grid.minor = element_blank(),
strip.text       = element_text(face = "bold", color = "black", hjust = 0.5),
strip.background = element_rect(color = "gray", fill = "white"),
legend.position  = "top",
legend.title = element_blank()
)


#### Save plots ----

ggarrange(g1, g2, ncol = 2, common.legend = FALSE)

ggsave(
  filename = "Output/Descriptive.png",
  #plot     = last_plot(),
  res      = 300,
  width    = 35,
  height   = 15,
  units    = 'cm',
  scaling  = 1,
  device   = ragg::agg_png
)

#### Maps -----

glimpse(table_fig)

# Food insecurity map 
p_if <- table_fig %>%
  ggplot() +
  geom_sf(aes(fill = prevalence_if, geometry = geometry),
          color = "black", size = 0.1) +
  #facet_wrap(~ macro, scales = "free_y") +
  scale_fill_fermenter(
    name = "Food Insecurity Prevalence (%)",
    palette = "YlOrRd", direction = 1,
    n.breaks = 5,
    guide = guide_colorbar(
      title.position  = "top",
      barwidth        = 10,
      barheight       = 0.5,
      direction       = "horizontal",
      label.theme     = element_text(size = 8)
    )
  ) +
  scale_x_continuous(limits = c(-78, -65), n.breaks = 4) +
  labs(
    title = "A.", # Food Insecurity Prevalence by Commune
    x = NULL, y = NULL
  ) +
  theme_light() +
  theme(
    plot.title        = element_text(size = 11, hjust = 0),
    strip.background  = element_rect(fill = NA, color = "black"),
    strip.text        = element_text(face = "bold", size = 9),
    panel.grid        = element_blank(),
    legend.position   = "top",
    legend.key.size   = unit(0.6, "cm"),
    legend.title      = element_text(size = 9, face = "bold"),
    legend.text       = element_text(size = 8)
  )

p_if

# Overcrowding map
p_oc <- table_fig %>%
  ggplot() +
  geom_sf(aes(fill = prevalence_oc, geometry = geometry),
          color = "black", size = 0.1) +
  #facet_wrap(~ macro, scales = "free_y") +
  scale_fill_fermenter(
    name = "Overcrowding Prevalence (%)",
    palette = "PuBuGn", direction = 1,
    n.breaks = 5,
    guide = guide_colorbar(
      title.position  = "top",
      barwidth        = 10,
      barheight       = 0.5,
      direction       = "horizontal",
      label.theme     = element_text(size = 8)
    )
  ) +
  scale_x_continuous(limits = c(-78, -65), n.breaks = 4) +
  labs(
    title = "B.", # Food Insecurity Prevalence by Commune
    x = NULL, y = NULL
  ) +
  theme_light() +
  theme(
    plot.title        = element_text(size = 11, hjust = 0),
    strip.background  = element_rect(fill = NA, color = "black"),
    strip.text        = element_text(face = "bold", size = 9),
    panel.grid        = element_blank(),
    legend.position   = "top",
    legend.key.size   = unit(0.6, "cm"),
    legend.title      = element_text(size = 9, face = "bold"),
    legend.text       = element_text(size = 8)
  )

p_oc

p_if | p_oc

ggsave(
  filename = "Output/Maps.png",
  #plot     = last_plot(),
  res      = 300,
  width    = 20,
  height   = 30,
  units    = 'cm',
  scaling  = 1,
  device   = ragg::agg_png
)
