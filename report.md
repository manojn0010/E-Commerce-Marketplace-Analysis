# E-Commerce Marketplace Analysis

## Abstract
This project analyzes a multi-table e-commerce marketplace dataset to understand
order behavior, revenue trends, delivery performance, and geographic patterns.

The analysis follows an **exploratory data analysis (EDA)** approach. Instead of
starting with predefined business questions, the dataset was first explored to
understand its structure, scale, and limitations. Based on insights from this
exploration, relevant business metrics (KPIs) were identified and analyzed.

The project demonstrates the use of:
- SQL (MySQL) for data querying and aggregation
- R for data manipulation and visualization

## Data Source

The dataset represents a Brazilian e-commerce marketplace and includes information
about orders, customers, sellers, products, payments, reviews, and logistics.

Data is stored in a MySQL database (`e-com`) and queried directly during analysis.
This ensures consistency between the raw data and analytical outputs.

Key tables used:
- `orders` – order details
- `order_items` – product-level pricing details
- `payments` – payment values and methods
- `customers` – customer information
- `sellers` – seller information
- `reviews` – customer review scores

Initial exploration focused on understanding:
- Table sizes and relationships
- Time coverage of orders
- Data completeness and potential inconsistencies

Key observations from EDA:
- Orders span between 2 to 3 years, enabling monthly time-series analysis
- Order-level and item-level tables require careful joins to avoid duplication
- Delivery-related timestamps vary across orders, affecting delivery performance metrics

This exploratory phase informed which metrics were meaningful and reliable for
further analysis.

## KPI Discovery and Definition

Based on EDA findings, the following KPIs were identified as meaningful indicators
of marketplace performance:

- **Gross Merchandise Value (GMV)**  
  Value of all the items moved on platform.

- **Average Order Value (AOV)**  
  Average cost per order, calculated as GMV divided by total orders.

- **State GMV Share**  
  Statewise aggregated results of Revenue.

- **State Rankings for Products**
  State rankings based on review scores for each product category

- **Category wise GMV Revenue**
  How much each state contributes towards GMV

- **Month-on-Month Gowth**
  Marketplace revenue trend

These metrics were not assumed upfront but emerged naturally from understanding
how orders, payments, reviews, and product-level data are structured in the database.

## Analysis and Insights

### Revenue Trends

Revenue and order volume were analyzed over time to identify trends and seasonality.

`![Revenue Trend Over Time](outputs/revenue_trend.png)`

The analysis shows clear temporal patterns in marketplace activity, with periods
of increased order volume corresponding to higher revenue.

---

### Geographic Performance

Orders and revenue were aggregated by customer state to understand regional
performance differences.

`![State-wise Performance](outputs/state_performance.png)`

A small number of states contribute disproportionately to total revenue,
highlighting geographic concentration in marketplace activity.

## Key Findings

- Revenue and order volume exhibit strong time-based patterns
- Marketplace activity is geographically concentrated
- Delivery performance appears linked to customer satisfaction
- KPI definitions must account for data granularity to avoid misinterpretation.

## Limitations and Next Steps

Limitations:
- Analysis is limited to available historical data
- Some delivery timestamps are missing or inconsistent
- Price details of some order items is missing
- Promotional or marketing effects are not directly captured

Next steps:
- Incorporate same state seller-customer analysis
- Build an interactive dashboard for KPI exploration
- Extend analysis to seller performance metrics.
