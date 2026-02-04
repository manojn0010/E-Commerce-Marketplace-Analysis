-- File: 05_procedures_and_functions.sql
-- Project: E-COM Analytics 

-- =========================
-- Create Procedures
 -- 1 orders_by_date
 -- 2 seller_metrics_by_state
-- =========================
-- 1 get orders within a time period 
create table if not exists orders_by_date
(order_id varchar(50),
order_date date,
customer_id varchar(50),
total_items int,
total_order_value decimal(10,2),
delivery_days int,
delivery_remark varchar(20));
-- -------------------------
delimiter $$

create procedure run_orders_by_date (in start_date date, in end_date date)
begin

truncate orders_by_date;

insert into orders_by_date 
(order_id, order_date, customer_id, total_items, total_order_value, delivery_days, delivery_remark)
select o.o_id, date(o.purchase_timestamp), o.c_id, count(oi.item_number), 
sum(oi.price+oi.freight_value), datediff(o.dlvy_date,o.purchase_timestamp),
	case 
		when o.dlvy_date is null then 'not delivered'
		when o.dlvy_date <= o.est_dlvy then 'on-time'
		else 'late'
	end
from orders o join order_items oi
on o.o_id = oi.o_id
where o.purchase_timestamp >= start_date 
  and o.purchase_timestamp < end_date + interval 1 day
group by o_id, purchase_timestamp, c_id, dlvy_date, est_dlvy
order by purchase_timestamp asc;

end$$

delimiter ;
-- -------------------------
-- -------------------------
-- 2 get overall seller metrics
create table if not exists seller_metrics_by_state
(state_code char(2),
sellers_count int,
areas_count int,
avrg_cost_per_order int,
dated_at timestamp);
-- -------------------------
delimiter $$

create procedure update_seller_metrics ()

begin
delete from seller_metrics_by_state;
insert into seller_metrics_by_state
(state_code, sellers_count, areas_count, avrg_cost_per_order, dated_at)
select s.s_state, 
       count(distinct s.s_id), 
       count(distinct s.s_zip_prefix), 
       round(sum(o.price+o.freight_value)/nullif(count(distinct o.o_id), 0), 2), 
       now() 
from sellers s
join order_items o on o.s_id = s.s_id
group by s.s_state;
end$$

delimiter ;
-- =========================

-- =========================
-- Create Functions
 -- 1 zip_cnt_by_state
 -- 2 order_cnt_by_state
 -- 3 cost
-- =========================
-- 1 get number of zip areas within state
delimiter $$

create function zip_cnt_by_state (state_code char(2))
returns int
deterministic

begin
declare zip_count int;
select count(distinct c_zip_prefix) into zip_count
from customers
where c_state = state_code;

return zip_count;
end$$

delimiter ;
-- -------------------------
-- 2 get total order counts from a state
delimiter $$

create function order_cnt_by_state (state_code char(2))
returns int
deterministic

begin
declare order_count int;
select count(distinct o.o_id) into order_count
from orders o
join customers c on o.c_id = c.c_id
where c.c_state = state_code;

return order_count;
end$$

delimiter ;
-- -------------------------
-- 3 function to return total cost of an order
delimiter $$

create function cost (order_id varchar(50))
returns decimal(10,2)
deterministic

begin
declare order_cost decimal(10,2);
select sum(price+freight_value) into order_cost
from order_items 
where o_id = order_id;

return order_cost;
end$$

delimiter ;
-- helps simplify the total cost operations
-- =========================