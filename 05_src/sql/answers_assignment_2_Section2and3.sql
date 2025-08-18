--  COALESCE Question 1
SELECT product_id,product_name,coalesce(product_size,'') AS product_size ,product_category_id,coalesce(product_qty_type,'unit') AS product_qty_type
FROM product
--  Windowed Functions Question 1 and Question 2
SELECT cp.market_date AS Latest_Visit,cp.customer_id,c.customer_first_name,c.customer_last_name
FROM (
SELECT DISTINCT(market_date) AS market_date,customer_id,dense_rank() OVER (PARTITION BY customer_id ORDER BY market_date DESC) AS Visit_Number
FROM customer_purchases) as cp
JOIN customer as c ON cp.customer_id = c.customer_id
WHERE Visit_Number = 1
--  Windowed Functions Question 3
SELECT DISTINCT(cp.product_id),cp.customer_id,count(cp.product_id) OVER (PARTITION BY cp.customer_id,cp.product_id) as Times_Purchased,c.customer_first_name,c.customer_last_name,p.product_name
FROM customer_purchases AS cp
JOIN customer AS c ON cp.customer_id = c.customer_id
JOIN product AS p on p.product_id = cp.product_id

-- String manipulations Question 1
SELECT *,
CASE WHEN instr(product_name,'-') > 0 THEN substr(product_name,instr(product_name,'-')+2,10)
     WHEN instr(product_name,'-') = 0 THEN NULL
END as Description
FROM product

-- UNION Question 1
SELECT market_date,max(total_sales)
FROM (
SELECT market_date, SUM((quantity * cost_to_customer_per_qty)) as total_sales
FROM customer_purchases
GROUP BY market_date)

UNION

SELECT market_date,min(total_sales)
FROM (
SELECT market_date, SUM((quantity * cost_to_customer_per_qty)) as total_sales
FROM customer_purchases
GROUP BY market_date)

--Cross Join Question 1
with t1 as (
SELECT vi.vendor_id,vi.product_id,SUM(vi.original_price) as total_hypothetical_sales
FROM (
SELECT *
FROM vendor_inventory 	
CROSS JOIN customer) as vi
GROUP by vi.vendor_id,vi.product_id)

SELECT p.product_name,vendor_name,total_hypothetical_sales
FROM t1 as vi
JOIN product as p ON vi.product_id = p.product_id
JOIN vendor as v ON v.vendor_id = vi.vendor_id

-- Insert Question 1
CREATE TABLE product_units AS SELECT * 
FROM product
WHERE product_qty_type = 'unit'

ALTER TABLE product_units
ADD COLUMN snapshot_timestamp  

UPDATE product_units
SET snapshot_timestamp = datetime('now')

INSERT INTO product_units (product_id,product_name,product_size,product_category_id,product_qty_type,snapshot_timestamp)VALUES (25,'Milkshake','10 oz',4,'unit',datetime('now'))

SELECT *
FROM product_units

-- DELETE Question 1
DELETE FROM product_units WHERE product_id = 25

-- UPDATE question 1
ALTER TABLE product_units
ADD COLUMN current_quantity  INT

CREATE TEMPORARY TABLE temp_vendor_inventory AS
SELECT product_id,quantity
FROM (
SELECT market_date,product_id,quantity,row_number() OVER (PARTITION by product_id ORDER BY market_date desc) AS _row_num
FROM vendor_inventory)
WHERE _row_num = 1


UPDATE product_units
SET current_quantity  = (
SELECt quantity
FROM temp_vendor_inventory AS A
WHERE  a.product_id =  product_units.product_id  )
WHERE product_id in (SELECT product_id FROM temp_vendor_inventory) 

SELECT * FROM product_units



