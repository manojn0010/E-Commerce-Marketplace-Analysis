-- File: 01_schema_and_tables.sql
-- Project: E-COM Analytics  

-- =========================
-- Schema Creation  
-- =========================
create schema `e-com`;
use `e-com`;

-- =========================
-- Table Creation for
 -- 1 sellers' data
 -- 2 customers' data
 -- 3 geolocation details
 -- 4 product details
 -- 5 order details
 -- 6 order items
 -- 7 payment details 
 -- 8 order reviews 
 -- 9 category names in english
-- =========================
create table sellers				-- 1                                                         
 (s_id varchar(50) primary key,
 s_zip_prefix int,
 s_city varchar(50),
 s_state varchar(10));
-- -------------------------
create table customers				-- 2
 (c_id varchar(50) primary key,
 c_unique_id varchar(50),
 c_zip_prefix int,
 c_city varchar(50),
 c_state varchar(10));
-- -------------------------  
create table geolocation			-- 3
 (zip_prefix int,
 g_lat decimal(10,7),
 g_lng decimal(10,7),
 g_city varchar(50),
 g_state varchar(10));
-- ------------------------- 
create table products				-- 4
 (p_id varchar(50) primary key,
 p_category varchar(100),
 name_len int,
 description_len int,
 photo_cnt int,
 weight_gms int,
 length_cm int,
 height_cm int,
 width_cm int);
-- ------------------------- 
create table orders					-- 5
 (o_id varchar(50) primary key,
 c_id varchar(50),
 o_status varchar(50),
 purchase_timestamp datetime,
 approved_at datetime,
 carrier_dlvydate datetime,
 dlvy_date datetime,
 est_dlvy datetime,
 foreign key (c_id) references customers(c_id));
 -- ------------------------- 
create table order_items			-- 6
 (o_id varchar(50),
 item_number int,
 p_id varchar(50),
 s_id varchar(50),
 shipping_limit_date datetime,
 price decimal(10,2),
 freight_value decimal(10,2),
 primary key (o_id, item_number),
 foreign key (o_id) references orders(o_id),
 foreign key (p_id) references products(p_id));
-- ------------------------- 
create table payments				-- 7
 (o_id varchar(50),
 payment_sequential int,
 payment_type varchar(50),
 installments int,
 payment_value decimal(10,2),
 primary key (o_id, payment_sequential),
 foreign key (o_id) references orders(o_id));
-- -------------------------
create table reviews 				-- 8
 (r_id varchar(50) primary key,
 o_id varchar(50),
 review_score int check (review_score between 1 and 5),
 comment_title varchar(100),
 comment_msg varchar(300),
 date_created datetime,
 submitted_timestamp datetime,
 foreign key (o_id) references orders(o_id));
-- ------------------------- 
create table cat_name_translation 	-- 9
 (category_name varchar(100) primary key,
 english_name varchar(100));
-- ==========================