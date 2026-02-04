-- File: 04_data_normalisation.sql
-- Project: E-COM Analytics  

-- =========================
-- Fix inconsistent data
-- Update the categories based on english names
-- Drop unnecessary columns that hinders the analysis
-- Drop geolocation duplicates
-- =========================
select distinct(p.p_category), english_name 
from products p 
left join cat_name_translation t 
on t.category_name = p.p_category 
order by english_name asc, p_category asc;
-- check category name consistency

update products
set p_category = 'portateis_casa_forno_e_cafe' 
where p_category = 'portateis_cozinha_e_preparadores_de_alimentos';
-- name fix

update cat_name_translation
set english_name = 'home_comfort' 
where category_name = 'casa_conforto';
-- name fix 

update products p
join cat_name_translation c
on c.category_name = p.p_category
set p.p_category = c.english_name;
-- update english product names

update products 
set p_category = 'unknown' 
where p_category is null;
-- set empty categories to 'unknown'

update products
set p_category = 'pcs' 
where p_category like '%pc%';
-- final name fix
-- -------------------------
select distinct(s_state) from sellers order by s_state asc;
select distinct(c_state) from customers order by c_state asc;
select distinct(g_state) from geolocation; 
-- all 26 states with 1 federal district, no extras
-- nothing to fix

select distinct(g_city) from geolocation order by g_city asc;  
-- thousands of cities with no master table for clean location data
-- drop city column in all tables
alter table geolocation
drop column g_city;
alter table sellers
drop column s_city;
alter table customers
drop column c_city;
-- proceed to work with zipcode prefix and state

alter table reviews
drop column comment_title,  
drop column comment_msg;
-- review title and message in a non-english language, hence dropped    
-- analysis uses review_score henceforth
-- -------------------------
delete g
from geolocation g
join (
    select
        zip_prefix, g_lat, g_lng, g_state,
        row_number() over (
            partition by zip_prefix, g_lat, g_lng, g_state
            order by zip_prefix
        ) as duplicates
    from geolocation
) temp
on  g.zip_prefix = temp.zip_prefix
and g.g_lat      = temp.g_lat
and g.g_lng      = temp.g_lng
and g.g_state    = temp.g_state
where temp.duplicates > 1;
-- delete duplicate records using row_number()
-- ==========================