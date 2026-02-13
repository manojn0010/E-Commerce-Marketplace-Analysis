-- File: 02_load_data.sql
-- Project: E-COM Analytics 

-- =========================
-- Load CSV Files into Tables
 -- 1 sellers
 -- 2 customers
 -- 3 geolocation
 -- 4 products
 -- 5 orders
 -- 6 order_items
 -- 7 payments
 -- 8 reviews
 -- 9 cat_name_translation
-- =========================
-- 1 sellers' data
load data infile "c:\\programdata\\mysql\\mysql server 8.0\\uploads\\p1\\olist_sellers_dataset.csv"
into table sellers
fields terminated by ','
optionally enclosed by '"'    
escaped by '"'                
lines terminated by '\n'
ignore 1 lines;                                                                 
-- -------------------------
-- 2 customers' data
load data infile "c:\\programdata\\mysql\\mysql server 8.0\\uploads\\p1\\olist_customers_dataset.csv"
into table customers
fields terminated by ','
optionally enclosed by '"'    
escaped by '"'               
lines terminated by '\n'
ignore 1 lines;                                                                            
-- -------------------------
-- 3 geolocation details
load data infile "c:\\programdata\\mysql\\mysql server 8.0\\uploads\\p1\\olist_geolocation_dataset.csv"
into table geolocation
fields terminated by ','
optionally enclosed by '"'   
escaped by '"'                
lines terminated by '\n'
ignore 1 lines;                        
-- -------------------------
-- 4 product details
load data infile 'c:\\programdata\\mysql\\mysql server 8.0\\uploads\\p1\\olist_products_dataset.csv'
into table products
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 lines
(p_id, p_category, @name_len, @desc_len, @photo_cnt,
 @weight, @length, @height, @width)
set
  name_len        = nullif(@name_len, ''),
  description_len = nullif(@desc_len, ''),
  photo_cnt       = nullif(@photo_cnt, ''),
  weight_gms      = nullif(@weight, ''),
  length_cm       = nullif(@length, ''),
  height_cm       = nullif(@height, ''),
  width_cm        = nullif(@width, '');
-- -------------------------
-- 5 order details
create table orders_stage (
  o_id varchar(50),
  c_id varchar(50),
  o_status varchar(50),
  purchase_ts varchar(30),
  approved_ts varchar(30),
  carrier_ts varchar(30),
  delivery_ts varchar(30),
  est_delivery_ts varchar(30)
);

load data infile 'c:\\programdata\\mysql\\mysql server 8.0\\uploads\\p1\\olist_orders_dataset.csv'
into table orders_stage
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 lines;

delete from orders_stage 
where o_status != "delivered";
-- only delivered orders are considered for this project

insert into orders
select s.o_id,
       trim(s.c_id),
       s.o_status,
       nullif(s.purchase_ts, ''),
       nullif(s.approved_ts, ''),
       nullif(s.carrier_ts, ''),
       nullif(s.delivery_ts, ''),
       nullif(s.est_delivery_ts, '')
from orders_stage s
join customers c
  on trim(s.c_id) = c.c_id;
-- -------------------------
-- 6 order items
create table order_items_stage (
  o_id varchar(50),
  item_number int,
  p_id varchar(50),
  s_id varchar(50),
  shipping_limit_date varchar(30),
  price decimal(10,2),
  freight_value decimal(10,2)
);

load data infile 'c:\\programdata\\mysql\\mysql server 8.0\\uploads\\p1\\olist_order_items_dataset.csv'
into table order_items_stage
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 lines;

insert into order_items
select
  s.o_id,
  s.item_number,
  s.p_id,
  s.s_id,
  nullif(s.shipping_limit_date, ''),
  s.price,
  s.freight_value
from order_items_stage s
join orders o
  on s.o_id = o.o_id;
-- -------------------------
-- 7 payment details 
create table payments_stage (
  o_id varchar(50),
  payment_sequential int,
  payment_type varchar(50),
  installments int,
  payment_value decimal(10,2)
);

load data infile 'c:\\programdata\\mysql\\mysql server 8.0\\uploads\\p1\\olist_order_payments_dataset.csv'
into table payments_stage
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 lines;

insert into payments
select
  s.o_id,
  s.payment_sequential,
  s.payment_type,
  nullif(s.installments, ''),
  s.payment_value
from payments_stage s
join orders o
  on s.o_id = o.o_id;
-- -------------------------
-- 8 order reviews  
create table reviews_stage (
  r_id varchar(50),
  o_id varchar(50),
  review_score int,
  comment_title varchar(100),
  comment_msg varchar(300),
  date_created varchar(100),
  submitted_timestamp varchar(100)
);

load data infile "c:\\programdata\\mysql\\mysql server 8.0\\uploads\\p1\\olist_order_reviews_dataset.csv"
into table reviews_stage
fields terminated by ','
optionally enclosed by '"'   
escaped by '"'               
lines terminated by '\n'
ignore 1 lines;

insert into reviews
select
  s.r_id,
  s.o_id,
  s.review_score,
  s.comment_title,
  s.comment_msg,
  nullif(s.date_created, ''),
  nullif(s.submitted_timestamp, '')
from (
  select *,
         row_number() over (
           partition by r_id
           order by submitted_timestamp desc
         ) as rn
  from reviews_stage
) s
join orders o
  on s.o_id = o.o_id
where s.rn = 1;
-- -------------------------
-- 9 category names in english
load data infile "c:\\programdata\\mysql\\mysql server 8.0\\uploads\\p1\\product_category_name_translation.csv"
into table cat_name_translation
fields terminated by ','
optionally enclosed by '"'  
escaped by '"'             
lines terminated by '\n'
ignore 1 lines;
-- =========================