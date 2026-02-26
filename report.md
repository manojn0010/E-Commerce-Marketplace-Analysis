# E-Commerce Marketplace Analysis Report

## Abstract
This project presents an end-to-end analytical study of a multi-seller e-commerce marketplace using the Brazilian Olist E-Commerce Public Dataset. The analysis integrates **SQL**-based data extraction and transformation with **R**-based visualization to evaluate marketplace performance across key dimensions, including revenue, order volume, geographic distribution, customer satisfaction, and product categories. A modular ETL pipeline is implemented to compute business-oriented KPIs such as **Gross Merchandise Value (GMV)**, **Average Order Value (AOV)**, and **Monthly Revenue Trends**. The results highlight regional revenue concentration, category-level performance, and temporal variations in marketplace activity. This project demonstrates practical *data analytics* skills, emphasizing structured data engineering, EDA-driven KPI framing, and clear communication of business insights.   

This report is meant to highlight the project structure, outcome and identifying other marketplace areas for further analysis.

---
## Objectives

The primary objectives of this project are:  
- Analyze overall marketplace performance using key revenue metrics  
- Identify top-performing states and product categories  
- Study monthly revenue and order trends  
- Build a structured SQL-to-R analytics pipeline  
- Demonstrate practical data analytics skills  

---
## Dataset Description

- **Source:** Brazilian Olist E-Commerce Public Dataset (Kaggle)
- **Nature:** Real-world marketplace data from a large Brazilian e-commerce platform
- **Coverage Includes:**
  - Orders and Order Items  
  - Payments  
  - Customers and Sellers  
  - Product categories  
  - Location Details (city, state)
  - Customer Reviews
The dataset is provided as multiple CSV files and loaded into a relational database for analysis.

----
## Tools & Technologies

- **SQL (MySQL)**  
  - Data loading  
  - Data cleaning and transformation  
  - KPI computation  
  - Analytical views  

- **R**  
  - Data visualization  
  - Trend analysis  
  - KPI plotting  

- **Key R Packages**
  - `DBI`, `RMySQL` – database connectivity  
  - `dplyr` – data manipulation  
  - `ggplot2` – visualization  
  - `zoo` – time-series handling  

---
## Data Engineering & ETL Workflow

1. **Data Ingestion**
   - Raw CSV files are loaded into MySQL tables.

2. **Data Cleaning**
   - Filtering invalid or incomplete records  
   - Handling missing cost and date values  
   - Normalizing date formats  

3. **Transformations**
   - Update Product categories with their english names 
   - Update unknown or null categories to "UNKNOWN" 
   - Drop textual reviews to avoid language inconsistency

4. **Analytical Views**
   - Modular SQL views created for KPIs and trends  
   - Rolling revenue and state-wise aggregations  
   - Creating derived columns (monthly buckets, revenue measures)  

5. **Execution**
   - A master SQL script runs the entire pipeline sequentially  
   - Ensures reproducibility and easy re-runs  

---
## Key Business Metrics Explored

- Revenue & Orders
  - Gross Merchandise Value (GMV)  
  - Total Order Count  
  - Average Order Value (AOV)  

- Time-Based Metrics
  - Statewise monthly rolling revenue  
  - Platform monthly revenue trend

- Geographic Metrics
  - Revenue contribution by state  
  - Top states by product category  

- Product & Seller Metrics
  - Top-rated product categories  
  - Statewise seller performance

---
## KPI Outcomes
1. **GMV**: BRL 15,419,626.88;  *Dated-Between: 2016-09-15 to 2018-08-29*    

2. **Order Count**: 96,477   
   **AOV**: BRL 159.83   

3. **Top 10 State Revenue Share**:  

| **state** | **state_rev**	| **gmv_percent_share** |
| :---: | :---: | :---: |
| SP | 6211822.27 | 37.60 |
| RJ | 2216415.56 | 13.42 |
| MG | 1941198.47 | 11.75 |
| RS | 936899.98 | 5.67 |
| PR | 830797.95 | 5.03 |
| SC | 642758.97 | 3.89 |
| BA | 629890.29 | 3.81 |
| DF | 362852.82 | 2.20 |
| GO | 354419.26 | 2.15 |
| ES | 342325.85 | 2.07 |

4. **Top 3 States for each Category**:
   ![An interactive shiny app displaying top 3 states, their rating, and order volume for the "Category" selected in dropdown.](outputs/r_visuals/KPI4_shiny_app.png)

5. **Category Ranks for Revenue Generated**:  

| **category** | **rev** | **rnk** |
| :--- | :---: | :---: |
|health_beauty|	1412089.53 |1|
|watches_gifts| 1264333.12 |2|
|bed_bath_table| 1225209.26	|3|
|sports_leisure| 1118256.91	|4|
|computers_accessories| 1032723.77 |5|
| : | : | : |
| : | : | : |
| : | : | : |
|security_and_services| 324.51 |72|

6. **Monthly Revenue Trend**:
   ![Trend shows slight decline in sales during mid months and at the end of the year.](outputs/r_visuals/KPI6_plot.png)
   
---
## Analysis Highlights
- Identified **high-revenue states** contributing disproportionately to total GMV  
- Observed **seasonality and growth patterns** in monthly revenue  
- Certain product categories consistently dominate order volume   

---
## Analytical Areas to Explore Further
- Extend analysis with customer segmentation  
- Build predictive models for revenue forecasting  
- Include orders with status other than "delivered" to find out how many actually go through  
- Timely Delivery Analysis. Find out if it correlates with customer reviews
- Explore payments to find customer payment preferences and timely payment settlement
  
---
## Conclusion
This project demonstrates practical, end-to-end data analytics skills — from raw data ingestion to business-ready insights.  
It reflects real-world analytical thinking, structured SQL design, and effective communication of results through visualization.

---
## References
- Dataset (Source): Brazilian Olist E-Commerce Public Dataset (Kaggle)
- Project Repository: <https://github.com/manojn0010/E-Commerce-Marketplace-Analysis/tree/main>
