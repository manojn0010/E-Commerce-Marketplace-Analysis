# E-Commerce-Marketplace-Analysis
A data analytics portfolio project built on the Brazilian Olist e-commerce dataset.

## Description
This project analyzes the Brazilian Olist e-commerce dataset, representing a real-world multi-seller marketplace, enabling exploration of product categories, customer reviews, and geographic performance. Using SQL for data extraction and KPI computation, the analysis focuses on key marketplace metrics such as, Gross Merchandise Value(GMV), Average Order Value(AOV), etc., and integrates these analytical results into an interactive dashboard, allowing users to dynamically filter product categories and examine top-performing states based on ratings and items sold.

SQL Language: MySQL
Visualised using: R

## How to run
1)  clone repository
2)  download the dataset from the given source
3)  from `scripts/`, run each script manually in order
 or
    perform the SQL end using `scripts/run_all/00_run_all.sql`
4)  visualise using R files in `viz_files/`

## Data Source
This project uses the Brazilian E-Commerce Public Dataset by Olist.

Due to file size limitations, the raw dataset is not included in this repository.

You can download the dataset from:
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

After downloading, extract the CSV files into:
data/

The SQL scripts in `scripts/` assume this folder structure.
