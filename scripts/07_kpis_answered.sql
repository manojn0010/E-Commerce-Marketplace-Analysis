-- File: 07_answer_kpis.sql
-- Project: E-COM Analytics 

-- =========================
-- Answer KPIs
 -- 1 What is the overall Gross Merchandise Value?
 -- 2 How GMV compares to Average Order Value using Order Count?
 -- 3 Combined Metrics of Sellers with more than 10 orders
 -- 4 Which are the top 3 states for each Product Category?
 -- 5 How much each State contributes towards total GMV?
 -- 6 Monthly Revenue Growth for each State
-- =========================
-- 1 gmv
select 
min(day_of_purchase) as from_date,
max(day_of_purchase) as to_date,
round(sum(cost), 2) as gmv 
from base_orders
where cost is not null;
-- -------------------------
-- 2 gmv vs aov
select 
count(distinct o_id) as order_cnt, 
round(sum(order_cost), 2) as gmv, 
round(sum(order_cost)/count(*), 2) as aov
from order_costs
where order_cost is not null;
-- -------------------------
-- 3 high_value_seller_metrics
with temp as (
    select s_id, sum(cost) as individual_value
    from base_orders
    where cost is not null
    group by s_id
    having count(s_id) > 10
)
select 
count(*) as high_value_seller_cnt, 
sum(individual_value) as seller_gmv, 
round(sum(individual_value)/count(*), 2) as high_value_sellers_avg_gmv
from temp;
-- -------------------------
-- 4 top 3 states for each category by rating
select * 
from state_rank_by_category
where rnk <= 3
and p_category != "unknown";
-- -------------------------
-- 5 state_gmv_percent_share
select state, round(100*ttl_price/sum(ttl_price) over (), 2) as seller_state_gmv_share
from state_ttl_price_rankings;
-- -------------------------
-- 6 growth_over_month
select *, (rev) - lag(rev) over(partition by state order by mnt) as growth_from_prev_mnt 
from rolling_rev_by_state;
-- =========================
