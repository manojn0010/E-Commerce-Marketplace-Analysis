# Project Documentation
Project: E-COM Analytics  
Scope: This document is intended for technical reviewers and focuses on data processing and analytical logic rather than dashboard usage.  

---
### Overview  
This document provides detailed technical documentation for the *E-COM Analytics* project, which analyzes the Brazilian Olist e-commerce dataset to derive marketplace insights. It captures the key challenges encountered during the data ingestion phase, such as data inconsistencies, constraint violations, and duplicate records, along with the systematic approaches used to resolve them. Additionally, the document outlines the data cleaning strategies, assumptions made during analysis, and the supporting database objects (procedures, functions, and views) created to enable efficient and reproducible analytics workflows.

---
### Key Performance Indicators (KPIs)
1. Gross Merchandise Value (GMV)  
> Sum of the value of the products moved through the platform.
2. Order Count and Average Order Value (AOV)  
> Total number of orders and mean order value per order
3. High Value Seller Metrics  
> Metrics of Sellers with more than 10 orders (High value threshold)
4. Top 3 States for each Category  
> Obtain the top states for each category based on customer ratings
5. State-wise GMV Share  
> How much each state contributes towards GMV 
6. State-wise Month-over-Month Growth  
> How sales vary across states on a rolling monthly basis

---
### Errors Fixed During Load Phase

**Incorrect Datatypes**
- Error code 1366: Incorrect integer value `''` for column `name_len`
- Error code 1292: Incorrect datetime value `''` for column `carrier_dlvydate`  
**Resolution:** Used session variables during load to validate and safely convert invalid values.

**Orphan Keys**
- Error code 1452: Foreign key constraint failure on `orders.c_id` referencing `customers.c_id`
- Error code 1452: Foreign key constraint failure on `order_items.o_id` referencing `orders.o_id`
- Error code 1452: Foreign key constraint failure on `payments.o_id` referencing `orders.o_id`  
**Resolution:** Built staging tables and filtered records based on the presence of valid keys in parent tables.

**Duplicate Records**
- Error code 1062: Duplicate entry for primary key in `reviews`  
**Resolution:** Applied a `ROW_NUMBER()` window function partitioned by `review_id` and ordered by `submit_timestamp`.  
Only entries with `ROW_NUMBER() = 1` are loaded into the final table.

**Summary:**
- Errors included incorrect datatypes, orphan keys, and duplicate entries.
- These issues occurred due to inconsistent CSV data files.
- Only final, corrected queries are retained in the `scripts/` directory.

---
### Data Cleaning Phase
- Staging tables act as temporary structures before final tables are populated and are dropped afterward.
- Product category names were standardized and mapped to English equivalents.
- Geolocation data was cross-checked for consistency.
- City names were inconsistent; analysis was performed using `zip_prefix` and `state_code`.
- Review text data was excluded due to language inconsistency.
- Duplicate geolocation records were reduced to a single retained entry.

---
### Procedures
1. run_orders_by_date    
> purpose: update orders_by_date based on dates  
> input: start_date (yyyy-mm-dd), end_date (yyyy-mm-dd)     
> output: truncates the table orders_by_date and updates orders from start_date to end_date     
2. update_seller_metrics
> purpose: update seller_metrics_by_state  
> input: none; directly updates seller metrics  
> output: truncates the table seller_metrics_by_state and updates aggregated results of seller metrics by state  

---
### Functions
1. zip_cnt_by_state  
> purpose: get the area count within a state  
> input: 2 character state_code  
> output: returns the number of areas within the state, based on current customer data   
2. order_cnt_by_state  
> purpose: get the number of orders from a state  
> input: 2 character state_code  
> output: returns the number of orders from the state, based on current orders data  
3. cost
> purpose: to obtain total cost of an order  
> input: alphanumeric order_id  
> output: returns the total cost of an order, i.e, sum of price and freight_value of each item

---
### Views  
1. order_costs  
> purpose: to obtain basic order data    
> tables: `orders` and `customers`  
> constraints: provides only the unique customer id and cost of the order  
> use case: KPI 2; handle null values    
2. base_orders
> purpose: to obtain detailed order data  
> tables: `orders`, `order_items` and `customers`  
> constraints: detailed order data, but includes null values    
> use case: KPI 1 and KPI 3; handle null values    
3. state_ttl_price_rankings
> purpose: to rank states on sum of order prices  
> tables: `sellers` joined to view `base_orders`  
> constraints: ranking based on seller states  
> use case: KPI 5; retain share percentage to 2 decimal places  
4. state_rank_by_category
> purpose: to rank states by review scores for each category  
> tables: `reviews`, `order_items`, `sellers` and `products`  
> constraints: based only sellers with more than 3 orders and known product categories   
> use case: KPI 4; filter top 3 from each category  
5. rolling_rev_by_state
> purpose: to calculate monthly running revenue by state  
> tables: `customers` joined to view `base_orders`  
> constraints: provides only the month-over-month rolling revenue  
> use case: KPI 6; calculate month-on-month growth directly while answering KPI  

---
### Visualisation
- This project is visualised using R. Users must create a file named `.Renviron` for safety reasons.
- The file `/.Renviron.example` contains the instructions and the template for `.Renviron`.
- Start running R scripts only after following these instructions. The `scripts/visualisation/` scripts fail otherwise.
- KPIs 1, 2 and 3 are only calculated. KPIs 4, 5 and 6 are plotted using ggplot and Shiny app.
- The Project Report can be found in `/outputs` as a Quarto document(`report.qmd`).

---
### Data Assumptions and Limitations
- Only orders with status = 'delivered' are included for analysis. orders with `o_status` as cancelled, unavailable, approved, etc are excluded.
- GMV includes both product price and freight value.
- Monetary values are assumed to be in BRL.
- Review text sentiment analysis is not included due to language variability.
- City-level analysis is avoided due to inconsistent naming.

