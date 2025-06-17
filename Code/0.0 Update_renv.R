# Code 0.0: Update renv Environment ----
# This script is for the original developer to update the renv.lock file
# Other researchers should NOT use this script

## Initialize renv if not already initialized ----
if (!require("renv")) install.packages("renv")
if (!file.exists("renv.lock")) {
  renv::init()
}

## Take snapshot of current environment ----
renv::snapshot()

## Print completion message ----
cat("\nrenv environment updated successfully!\n")
cat("New renv.lock file created with current package versions.\n")
cat("Commit this file to the repository to share the environment with other researchers.\n\n") 