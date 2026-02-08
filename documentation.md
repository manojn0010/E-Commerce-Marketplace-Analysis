**Errors fixed during load phase:**

#### Incorrect Datatype                                                                                 
**error code: 1366. incorrect integer value: '' for column 'name_len' at row 105                                                                                 
error code: 1292. incorrect datetime value: '' for column 'carrier_dlvydate' at row 6**  
*resolution: Used session variables to validate data.*

#### Orphan Keys  
**error code: 1452. cannot add or update a child row: a foreign key constraint fails (`e_com`.`orders`, constraint `orders_ibfk_1` foreign key (`c_id`) references `customers` (`c_id`))  
error code: 1452. cannot add or update a child row: a foreign key constraint fails (`e_com`.`order_items`, constraint `order_items_ibfk_1` foreign key (`o_id`) references `orders` (`o_id`))    
error code: 1452. cannot add or update a child row: a foreign key constraint fails (`e_com`.`payments`, constraint `payments_ibfk_1` foreign key (`o_id`) references `orders` (`o_id`))**  
*resolution: Built stage_tables and filtered data based on keys present in parent table.*  

#### Duplicates  
**error code: 1062. duplicate entry '3242cc306a9218d0377831e175d62fbf' for key 'reviews.primary'**  
*resolution: Built row_number() window function, partitioned by review_id and ordered by submit_timestamp. Only the entries with row_number() = 1 is loaded into table.*  
  
- errors include incorrect datatype, orphan keys and duplicate entries    
- occurred due to inconsistent csv data files  
- only the final queries retained in `scripts/`    

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
