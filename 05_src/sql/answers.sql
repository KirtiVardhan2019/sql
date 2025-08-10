SELECT *
FROM customer
ORDER BY customer_last_name,customer_first_name
LIMIT 10 

SELECT *
FROM customer_purchases
WHERE product_id in (4,9)

SELECT *,(quantity * cost_to_customer_per_qty) as price
FROM customer_purchases
where vendor_id BETWEEN 8 AND 10

SELECT *,
CASE 
WHEN product_qty_type != 'unit' THEN 'bulk'
WHEN product_qty_type = 'unit' THEN 'unit'
END AS prod_qty_type_condensed,
CASE 
WHEN product_name LIKE '%Pepper%' THEN 1
ELSE 0
END AS pepper_flag
FROM product

SELECT *,b.booth_number,b.market_date
FROM vendor AS a
JOIN vendor_booth_assignments as b ON a.vendor_id = b.vendor_id
ORDER BY vendor_name,market_date

SELECT vendor_type,COUNT(booth_number) AS Rented_times
FROM vendor AS a
JOIN vendor_booth_assignments as b ON a.vendor_id = b.vendor_id
GROUP BY vendor_type

SELECT *
from customer

SELECT a.customer_id,b.customer_first_name,b.customer_last_name,SUM(a.quantity*a.cost_to_customer_per_qty)AS spend
FROM customer_purchases AS a
JOIN customer AS b ON a.customer_id =  b.customer_id
GROUP BY a.customer_id
HAVING spend >= 2000 
ORDER BY b.customer_last_name,b.customer_first_name

CREATE TABLE "temp.new_vendor" AS SELECT * FROM VENDOR

SELECT *
FROM "temp.new_vendor"

INSERT INTO "temp.new_vendor" ("vendor_id","vendor_name","vendor_type","vendor_owner_first_name","vendor_owner_last_name")
VALUES (10,"Thomass Superfood Store","Fresh Focused store","Thomas","Rosenthal")
