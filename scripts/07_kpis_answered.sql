-- File: 07_answer_kpis.sql
-- Project: E-COM Analytics 

-- =========================
-- Answer KPIs
 -- 1 What is the overall Gross Merchandise Value?
 -- 2 How GMV compares to Average Order Value using Order Count?
 -- 3 Top 10 Statewise Revenue Share
 -- 4 Which are the top 3 states for each Product Category?
 -- 5 Category Ranks by Revenue
 -- 6 Monthly Revenue Trend
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
-- 3 top 10 states by revenue
select *, round(100*state_rev/(sum(state_rev) over ()), 2) as gmv_percent_share 
from
(select state, sum(rev) as state_rev 
from rolling_rev_by_state
group by state) b
order by state_rev desc
limit 10;
-- -------------------------
-- 4 top 3 states for each category by rating
select * 
from state_rank_by_category
where rnk <= 3;
-- -------------------------
-- 5 category_rev_ranks
select *, rank () over (order by rev desc) as rnk
from category_rank_by_rev
where category != 'UNKNOWN';
-- -------------------------
-- 6 Platform Revenue Trend
select date_format(day_of_purchase, '%y-%m') as mnt, 
sum(cost) as rev
from base_orders
group by mnt
order by mnt;
-- =========================
