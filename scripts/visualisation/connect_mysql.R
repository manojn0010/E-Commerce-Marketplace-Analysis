# install the necessary packages
install.packages(c("DBI", "RMySQL"))  # for database handling
install.packages(c("dplyr", "ggplot2", "zoo"))  # for cleaning, plotting and time-series plots
install.packages("shiny") # for interactive plots


library(DBI)
library(RMySQL)

con <- dbConnect(
  RMySQL::MySQL(),
  dbname   = "e-com",
  host     = "localhost",
  user     = "@username",
  password = "@password"
)
