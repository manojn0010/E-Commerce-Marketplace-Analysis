# File: v2_kpis.R
# Project: E-COM Analytics  
# Purpose: Load KPIs as Objects 

# Load necessary libraries
library(dplyr)

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
                         where order_cost is not null")

# 3. High-Value Seller Metrics
high_value_sellers <- dbGetQuery(con, "
                                 with temp as(
                                 select
                                 s_id,
                                 sum(cost) as individual_value
                                 from base_orders
                                 where cost is not null
                                 group by s_id
                                 having count(s_id) > 10)
                                 select *
                                 from temp
                                 ")

high_value_summary <- high_value_sellers %>%
  summarise(
    high_value_seller_cnt = n(),
    high_seller_gmv = round(sum(individual_value), 2),
    high_value_sellers_avg_gmv = round(mean(individual_value), 2)
  )

# 4. Top 3 States for each Category
top_states_by_category <- dbGetQuery(con, "
                                     select *
                                     from state_rank_by_category
                                     where rnk <= 3
                                     and p_category != 'unknown'
                                     ")
top_states_by_category <- top_states_by_category %>% mutate(p_category=trimws(p_category))
# Later made into an interactive plot using shiny.

# 5. State-wise GMV Share
state_gmv_share <- dbGetQuery(con, "
                              select 
                              state, 
                              round(100*ttl_price/sum(ttl_price) over(), 2) as gmv_percent_share
                              from state_ttl_price_rankings
                              ")

# 6. Each State Month-on-Month Growth
state_growth_by_mnt <- dbGetQuery(con, "
                                  select *,
                                  rev-lag(rev) over(partition by state order by mnt) as growth_from_prev_mnt
                                  from rolling_rev_by_state
                                  ")
# Later made into an interactive plot using shiny.
