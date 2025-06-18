# Code 0.0: Setup Environment ----

## Package Management ----

# List of required packages
required_packages <- c(
  # Data manipulation and analysis
  "tidyverse",    # Data manipulation and visualization
  "rio",          # Data import/export
  "haven",        # Import SAS, SPSS, Stata files
  "survey",       # Survey analysis
  "srvyr",        # Survey analysis with tidyverse
  "writexl",       # Save excel files
  
  # Modeling
  "broom",        # Tidy model outputs
  "car",          # Companion to Applied Regression
  "pROC",         # ROC curves
  "ResourceSelection", # Hosmer-Lemeshow test
  "MASS",          # Binomial negative models 
  "pscl",          # Zero inflated models
  
  # Output
  "openxlsx",     # Excel files
  "knitr",        # Dynamic report generation
  "rmarkdown",    # R Markdown
  "kableExtra",   # Enhanced table formatting
  "tableone",     # Summary tables
  "gtsummary",     # Edit table format
  "chilemapas",     # Maps
  
  # Visualization
  "ggplot2",      # Advanced plotting
  "ggthemes",     # Additional themes
  "scales",       # Scale functions for visualization
  "ggridges",     # Special plot
  "patchwork",    # Compile plots
  "sf",           # Plot maps
  "ggrepel",      # Especial plots
  "ggpubr",        # Sort plots
  "patchwork",     # Plot save
  
  # Development
  "devtools",     # Development tools
  "roxygen2",     # Documentation
  "testthat"      # Testing
)

# Function to install and load packages
install_and_load <- function(package) {
  if (!require(package, character.only = TRUE)) {
    install.packages(package)
    library(package, character.only = TRUE)
  }
}

# Function to verify and load required packages
verify_packages <- function() {
  # Check if packages are installed and load them
  sapply(required_packages, install_and_load)
  
  # Return TRUE if all packages are loaded successfully
  all(sapply(required_packages, require, character.only = TRUE))
}

# Initial package loading
verify_packages()

## Verify project structure ----
# Expected directory structure
expected_dirs <- c(
  "Input",
  "Output",
  "Code",
  "Paper"
  #"Figures",
  #"Tables"
)

# Check which directories exist and which need to be created
missing_dirs <- expected_dirs[!dir.exists(expected_dirs)]

if (length(missing_dirs) > 0) {
  # Create only missing directories
  sapply(missing_dirs, function(dir) {
    dir.create(dir)
    cat("Created directory:", dir, "\n")
  })
} else {
  cat("All required directories already exist.\n")
}

## Save session info ----
session_info <- sessionInfo()
saveRDS(session_info, "Output/session_info.rds")

## Print setup completion message ----
cat("\nSetup completed successfully!\n")
cat("Package environment verified.\n")
cat("Session info saved to Output/session_info.rds\n\n")

# Export the verify_packages function to the global environment
assign("verify_packages", verify_packages, envir = .GlobalEnv) 