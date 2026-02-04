-- File: 03_drop_stages_and_handle_nulls.sql
-- Project: E-COM Analytics 

-- =========================
-- Drop Stage Tables
-- =========================
drop table orders_stage;
drop table order_items_stage;
drop table payments_stage;
drop table reviews_stage;
-- stage tables contain orphan foreign keys
-- they are not included in the analysis

-- =========================
-- Null Handling
-- =========================
update sellers 
set 
  s_zip_prefix = nullif(s_zip_prefix, ''),
  s_city = nullif(s_city, ''),
  s_state = nullif(s_state, '');
-- -------------------------
update customers 
set 
  c_unique_id = nullif(c_unique_id, ''),
  c_zip_prefix = nullif(c_zip_prefix, ''),
  c_city = nullif(c_city, ''),
  c_state = nullif(c_state, '');
-- -------------------------
update geolocation 
set 
  zip_prefix = nullif(zip_prefix, ''),
  g_city = nullif(g_city, ''),
  g_state = nullif(g_state, '');
-- -------------------------
update products 
set p_category = nullif(p_category, '');
-- -------------------------
update cat_name_translation
set
  english_name = nullif(english_name, '');
-- =========================