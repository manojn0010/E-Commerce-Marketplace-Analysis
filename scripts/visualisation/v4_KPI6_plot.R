# File: v4_KPI6_plot.R
# Project: E-COM Analytics  
# Purpose: Plot KPI 6 using Shiny App

# Libraries
library(ggplot2)  # plotting
library(zoo)      # yearmon time handling

# Convert month column to proper monthly time format
monthly_trend$mnt <- as.yearmon(
  monthly_trend$mnt,
  format = "%y-%m"
)

# Time-Series Plot: Platform Revenue Trend
ggplot(monthly_trend, aes(x = mnt, y = rev, group = 1)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_x_yearmon(format = "%b %Y") +
  labs(
    title = "Platform Revenue Trend (Monthly)",
    x = "Month",
    y = "Revenue"
  ) +
  theme_minimal()
