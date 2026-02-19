# File: v1_connect_mysql.R
# Project: E-COM Analytics  
# Purpose: Create DBI Connection Object

# Load necessary libraries
library(DBI)
library(RMySQL)

# Create object that connect to MySQL
con <- dbConnect(
  RMySQL::MySQL(),
  dbname   = "e-com",
  host     = Sys.getenv("MYSQL_HOST", "localhost"),
  user     = Sys.getenv("MYSQL_USER"),
  password = Sys.getenv("MYSQL_PASSWORD")
)

