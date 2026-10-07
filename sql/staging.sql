-- First create main (center) table of the orders 
CREATE OR REPLACE TABLE stg_orders AS
SELECT 
    order_id,
    customer_id,
    CAST(order_purchase_timestamp AS TIMESTAMP) AS purchase_timestamp,
    CAST(order_estimated_delivery_date AS TIMESTAMP) AS estimated_delivery_timestamp,
   (DATE_DIFF('second', CAST(order_purchase_timestamp AS TIMESTAMP),
    CAST(order_delivered_customer_date AS TIMESTAMP))/86400) AS delivery_time
FROM read_csv_auto('data/raw/olist_orders_dataset.csv')
WHERE  order_status='delivered'
AND 
order_delivered_customer_date IS NOT NULL ;

-- Creating the table for the items-sellers for each order
CREATE OR REPLACE TABLE stg_order_items AS
SELECT
    order_id,
    COUNT(*) AS n_items,
    SUM(price) AS total_price,
    SUM(freight_value) AS total_freight,
    COUNT(DISTINCT seller_id) AS n_sellers,
    ANY_VALUE(seller_id) AS seller_id
FROM read_csv_auto('data/raw/olist_order_items_dataset.csv')
GROUP BY order_id;




CREATE OR REPLACE TABLE stg_sellers AS
SELECT 
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM read_csv_auto('data/raw/olist_sellers_dataset.csv');

CREATE OR REPLACE TABLE stg_customers AS
SELECT
    customer_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM read_csv_auto('data/raw/olist_customers_dataset.csv');

-- One row per zip prefix (raw file has many lat/lng rows per prefix ) 
CREATE OR REPLACE TABLE stg_geolocation AS
SELECT
    geolocation_zip_code_prefix,
    AVG(geolocation_lat) AS geolocation_lat,
    AVG(geolocation_lng) AS geolocation_lng
FROM read_csv_auto('data/raw/olist_geolocation_dataset.csv')
GROUP BY geolocation_zip_code_prefix;


CREATE OR REPLACE TABLE full_data AS
SELECT 
    a.order_id,
    a.purchase_timestamp,
    a.estimated_delivery_timestamp,
    b.n_items,
    b.total_price,
    b.total_freight,
    b.n_sellers,
    c.seller_city,
    c.seller_state,
    d.geolocation_lat AS seller_latitude,
    d.geolocation_lng AS seller_longitude,
    e.customer_city,
    e.customer_state,
    f.geolocation_lat AS customer_latitude,
    f.geolocation_lng AS customer_longitude,
    a.delivery_time
FROM stg_orders a 
JOIN stg_order_items b ON a.order_id = b.order_id
JOIN stg_sellers c ON b.seller_id = c.seller_id
JOIN stg_customers e ON a.customer_id = e.customer_id
LEFT JOIN stg_geolocation d ON c.seller_zip_code_prefix = d.geolocation_zip_code_prefix
LEFT JOIN stg_geolocation f ON e.customer_zip_code_prefix = f.geolocation_zip_code_prefix;







