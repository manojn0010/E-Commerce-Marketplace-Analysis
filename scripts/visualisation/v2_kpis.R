# File: v2_kpis.R
# Project: E-COM Analytics  
# Purpose: Load KPIs as Objects 

# Load necessary libraries
library(dplyr)

# Key Performance Indicators
# 1. Gross Merchandise Value
gmv <- dbGetQuery(con, "
                  select 
                  min(day_of_purchase) as from_date,
                  max(day_of_purchase) as to_date,
                  round(sum(cost), 2) as gmv
                  from base_orders
                  where cost is not null
                  ")

# 2. Order Count and Average Order value
gmv_vs_aov <- dbGetQuery(con, "
                         select
                         count(distinct o_id) as order_count,
                         round(sum(order_cost), 2) as gmv,
                         round(sum(order_cost)/count(*), 2) as aov
                         from order_costs
                         where order_cost is not null
                         ")

# 3. Top 10 States by Revenue Share
top_10_states <- dbGetQuery(con, "
                            select *, 
                            round(100*state_rev/(sum(state_rev) over ()), 2)as gmv_percent_share 
                            from
                            (select state, sum(rev) as state_rev 
                            from rolling_rev_by_state
                            group by state) b
                            order by state_rev desc
                            limit 10
                            ")

# 4. Top 3 States for each Category
top_states_by_category <- dbGetQuery(con, "
                                     select *
                                     from state_rank_by_category
                                     where rnk <= 3
                                     and p_category != 'unknown'
                                     ")
top_states_by_category <- top_states_by_category %>% mutate(p_category=trimws(p_category))
# Later made into an interactive plot using shiny.

# 5. Rank Product Categories based on Revenue
category_rev_ranks <- dbGetQuery(con, "
                                 select *, 
                                 rank () over (order by rev desc)
                                 from category_rank_by_rev
                                 where category != 'UNKNOWN'
                                 ")

# 6. Platform Revenue Trend
monthly_trend <- dbGetQuery(con, "
                            select date_format(day_of_purchase, '%y-%m') as mnt, 
                            sum(cost) as rev
                            from base_orders
                            group by mnt
                            order by mnt
                            ")
# Used in Time-Series Plot

# Terminate DB Connection after creating KPI Objects. 
dbDisconnect(con)

