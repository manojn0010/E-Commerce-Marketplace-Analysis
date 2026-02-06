# E-Commerce Marketplace Analysis
A data analytics portfolio project built on the Brazilian Olist e-commerce dataset.

## Description
This project analyzes the Brazilian Olist e-commerce dataset, representing a real-world multi-seller marketplace. It enables exploration of product categories, customer reviews, and geographic performance across Brazilian states.

Using SQL for data extraction and KPI computation, the analysis focuses on key marketplace metrics such as Gross Merchandise Value (GMV), Average Order Value (AOV), and regional performance indicators. These analytical results are integrated into an interactive dashboard that allows users to dynamically filter product categories and examine top-performing states based on customer ratings and items sold.

### Tools used
**SQL:** MySQL  
**Visualization:** R

## How to Run
1. Clone the repository.
2. Download the dataset from the source listed below.
3. Extract the CSV files into the `data/` directory.
4. From `scripts/`, run each script manually in order  
   **or** execute the full pipeline using: scripts/run_all/00_run_all.sql   
5. Generate visualizations using the R scripts in `viz_files/`.

## Data Source
This project uses the Brazilian E-Commerce Public Dataset by Olist.

Due to file size limitations, the raw dataset is not included in this repository.

You can download the dataset from:
https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

After downloading, extract the CSV files into:
data/

The SQL scripts in `scripts/` assume this folder structure.
