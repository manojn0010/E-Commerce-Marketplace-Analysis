# File: v4_KPI5_plot.R
# Project: E-COM Analytics  
# Purpose: Plot KPI 5

# Load necessary libraries
library(ggplot2)
library(zoo)

# Load KPI5 Data
top5_state_gmv <- state_gmv_share %>%
  slice(1:5)

# Plotting
ggplot(
  top5_state_gmv,
  aes(
    x = reorder (state, gmv_percent_share ),
    y = gmv_percent_share
  )
) +
  geom_col(fill = "blue") +
  geom_text(
    aes(label = paste0(gmv_percent_share, "%")),
    hjust = -0.1
  ) +
  coord_flip () +
  labs(
    title = "Top 5 States by GMV Share",
    x = "State",
    y = "GMV Share (%)"
  )
