# Project Documentation
Project: E-COM Analytics

### Overview


### Errors Fixed During Load Phase

**Incorrect Datatypes**
- Error code 1366: Incorrect integer value `''` for column `name_len`
- Error code 1292: Incorrect datetime value `''` for column `carrier_dlvydate`
**Resolution:**  
Used session variables during load to validate and safely convert invalid values.


**Orphan Keys**
- Error code 1452: Foreign key constraint failure on `orders.c_id` referencing `customers.c_id`
- Error code 1452: Foreign key constraint failure on `order_items.o_id` referencing `orders.o_id`
- Error code 1452: Foreign key constraint failure on `payments.o_id` referencing `orders.o_id`
**Resolution:**  
Built staging tables and filtered records based on the presence of valid keys in parent tables.


**Duplicate Records**
- Error code 1062: Duplicate entry for primary key in `reviews`
**Resolution:**  
Applied a `ROW_NUMBER()` window function partitioned by `review_id` and ordered by `submit_timestamp`.  
Only entries with `ROW_NUMBER() = 1` are loaded into the final table.

**Summary:**
- Errors included incorrect datatypes, orphan keys, and duplicate entries.
- These issues occurred due to inconsistent CSV data files.
- Only final, corrected queries are retained in the `scripts/` directory.

### Data Cleaning Phase

- Staging tables act as temporary structures before final tables are populated and are dropped afterward.
- Product category names were standardized and mapped to English equivalents.
- Geolocation data was cross-checked for consistency.
- City names were inconsistent; analysis was performed using `zip_prefix` and `state_code`.
- Review text data was excluded due to language inconsistency.
- Duplicate geolocation records were reduced to a single retained entry.

---

### Procedures, Functions, and Views
- Additional tables such as `orders_by_date` and `seller_metrics_by_state` are updated based on a user-defined date range (`YYYY-MM-DD` format)
