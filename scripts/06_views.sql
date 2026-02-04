-- File: 06_views.sql
-- Project: E-COM Analytics 

-- =========================
-- Create Views
 -- 1 order_costs
 -- 2 base_orders
 -- 3 state_rev_rankings
 -- 4 state_rank_by_category
 -- 5 rolling_rev_by_state
-- =========================
-- 1 view using function
create view order_costs as
select 
o.o_id, c_unique_id, cost(o.o_id) as order_cost
from orders o 
join customers c on o.c_id = c.c_id;
-- order_id with the unique customer_id and order cost
-- -------------------------
-- 2 create base order-items view
create view base_orders as
select 
o.o_id as o_id, 
oi.item_number as item, 
date(o.purchase_timestamp) as day_of_purchase, 
c.c_unique_id as c_id, 
oi.s_id as s_id, 
oi.price + oi.freight_value as cost
from orders o
left join order_items oi on o.o_id = oi.o_id
join customers c on o.c_id = c.c_id;
-- detailed order data
-- -------------------------
-- 3 ranking view using base view
create view state_ttl_price_rankings as
select s.s_state as state, 
sum(o.cost) as ttl_price, 
rank() over (order by sum(o.cost) desc) as rnk 
from base_orders o
join sellers s 
on o.s_id = s.s_id 
group by s.s_state;
-- rank states on total order prices
-- -------------------------
-- 4 view using ctes
create view state_rank_by_category as                    
with cte1 as (
select o.o_id, p.p_category, s.s_state, r.review_score
from reviews r 
join order_items o on r.o_id = o.o_id 
join sellers s on o.s_id = s.s_id 
join products p on o.p_id = p.p_id
),
cte2 as (
select p_category, s_state, count(*) as item_count, round(avg(review_score), 2) as avg_rating
from cte1 
group by p_category, s_state 
having item_count >= 4
)
select *, dense_rank() over (partition by p_category order by avg_rating desc) as rnk
from cte2;
-- ranking states by category of products and review scores
-- -------------------------
-- 5 subquery view with rolling window
create view rolling_rev_by_state as                         
select state, date_format(mnt_start, '%y-%m') as mnt, rev,
sum(rev) over (
  partition by state 
  order by mnt_start 
  rows between unbounded preceding and current row
) as mntly_running_rev
from (
  select c.c_state as state, 
         date_format(b.day_of_purchase, '%y-%m-01') as mnt_start, 
         sum(cost) as rev
  from base_orders b 
  join customers c on b.c_id = c.c_unique_id
  group by state, mnt_start
) state_monthly_rev
order by state, mnt_start;
-- monthly running revenue by state
-- =========================