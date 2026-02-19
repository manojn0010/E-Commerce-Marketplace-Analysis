# File: v0_set_up.R
# Project: E-COM Analytics
# Purpose: Install required R packages if they are not already installed  

# Run this script once before executing any other project visualisation scripts.

required_packages <- c(
  "DBI",
  "RMySQL",
  "dplyr",
  "ggplot2",
  "zoo",
  "shiny"
)

installed <- rownames(installed.packages())

for (pkg in required_packages) {
  if (!pkg %in% installed) {
    install.packages(
      pkg,
      dependencies = TRUE,
      ask = FALSE
    )
  }
}
