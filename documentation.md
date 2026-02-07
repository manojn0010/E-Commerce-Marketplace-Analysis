**Errors fixed during load phase:**

*the error is given along with the --step and query*  
*performed in a native computer, the `/path` is not relative to final scripts in repo*

-- 4 product details  
load data infile "/path"
into table products
fields terminated by ','
optionally enclosed by '"'   
escaped by '"'               
lines terminated by '\n'
ignore 1 lines;                                                                                
-- error1: error code: 1366. incorrect integer value: '' for column 'name_len' at row 105

-- 5 order details   
load data infile "/path"
into table orders
fields terminated by ','
optionally enclosed by '"'  
escaped by '"'               
lines terminated by '\n'
ignore 1 lines;                                                                                 
-- error code: 1292. incorrect datetime value: '' for column 'carrier_dlvydate' at row 6  

load data infile "/path"  
into table orders
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 lines
(o_id, @cid, o_status,
 @purchase_ts, @approved_ts,
 @carrier_ts, @delivery_ts, @est_delivery_ts)
set
  c_id               = trim(@cid),
  purchase_timestamp = nullif(@purchase_ts, ''),
  approved_at        = nullif(@approved_ts, ''),
  carrier_dlvydate   = nullif(@carrier_ts, ''),
  dlvy_date          = nullif(@delivery_ts, ''),
  est_dlvy           = nullif(@est_delivery_ts, '');  
-- error code: 1452. cannot add or update a child row: a foreign key constraint fails (`e_com`.`orders`, constraint `orders_ibfk_1` foreign key (`c_id`) references `customers` (`c_id`))

-- 6 order items  
load data infile "/path"
into table order_items
fields terminated by ','
optionally enclosed by '"'   
escaped by '"'                
lines terminated by '\n'
ignore 1 lines;  
-- error code: 1452. cannot add or update a child row: a foreign key constraint fails (`e_com`.`order_items`, constraint `order_items_ibfk_1` foreign key (`o_id`) references `orders` (`o_id`))  

-- 7 payment details  
load data infile "/path"
into table payments
fields terminated by ','
optionally enclosed by '"'   
escaped by '"'               
lines terminated by '\n'
ignore 1 lines;    
-- error code: 1452. cannot add or update a child row: a foreign key constraint fails (`e_com`.`payments`, constraint `payments_ibfk_1` foreign key (`o_id`) references `orders` (`o_id`))  

-- 8 order reviews   
load data infile "/path"
into table reviews
fields terminated by ','
optionally enclosed by '"'   
escaped by '"'               
lines terminated by '\n'
ignore 1 lines;  
-- error code: 1062. duplicate entry '3242cc306a9218d0377831e175d62fbf' for key 'reviews.primary'  

*occured due to inconsistent csv data files*  
*errors include incorrect datatype, orphan keys and duplicate entries*  
*only the final queries retained in `scripts/`*  

**Data Cleaning phase:**  

- stage_tables act as a temporary table before final_table is populated, dropped later  
- orphan customers having no valid details, are dropped during load  
- fixed product_category names  
- cross-checked geolocation data  
- city names not suitable for working or fixing, hence analysis is done using zip_prefix and state_code  
- quantitative data driven analysis, review messages in unknown language, hence dropped  
- geolocation contains several duplicates, only a single record of each retained  

**Procedures, Functions and Views:**
- additional tables 'orders_by_date' and 'seller_metrics_by_state' are updated based on start_date to end_date (yyyy-mm-dd format) and 
