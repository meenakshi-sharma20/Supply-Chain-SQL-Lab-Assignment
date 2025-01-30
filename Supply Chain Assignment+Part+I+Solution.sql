use supply_db ;


Question : Golf related products

List all products in categories related to golf. Display the Product_Id, Product_Name in the output. Sort the output in the order of product id.
Hint: You can identify a Golf category by the name of the category that contains golf.

*/
SELECT 
   Product_Name, 
   Product_Id
FROM 
   product_info
INNER JOIN
   category ON product_info.Category_Id = category.Id
WHERE 
   category.Name LIKE "%Golf%" 
ORDER BY
   Product_Id ;
-- **********************************************************************************************************************************

/*
Question : Most sold golf products

Find the top 10 most sold products (based on sales) in categories related to golf. Display the Product_Name and Sales column in the output. Sort the output in the descending order of sales.
Hint: You can identify a Golf category by the name of the category that contains golf.

HINT:
Use orders, ordered_items, product_info, and category tables from the Supply chain dataset.


*/


SELECT
   Product_Name,
   Sales
FROM
   (
   SELECT
      prod_info.Product_Name,
      SUM(Sales) AS Sales,
      RANK() OVER(ORDER BY SUM(Sales) DESC) AS Sales_Rank
   FROM
      orders AS ord
   LEFT JOIN
      ordered_items AS ord_itm ON ord.Order_Id = ord_itm.Order_Id
   LEFT JOIN
      product_info AS prod_info ON ord_itm.Item_Id=prod_info.Product_Id
   LEFT JOIN
      category AS cat ON prod_info.Category_Id =cat.Id
   WHERE
      LOWER(cat.Name) LIKE '%golf%'
   GROUP BY 1
   ORDER BY 2 DESC
) AS summary
WHERE 
   Sales_Rank<=10;
-- **********************************************************************************************************************************

/*
Question: Segment wise orders

Find the number of orders by each customer segment for orders. Sort the result from the highest to the lowest 
number of orders.The output table should have the following information:
-Customer_segment
-Orders


*/

SELECT 
   ci.Segment AS customer_segment, 
   count(o.Order_Id) AS Orders
FROM 
   customer_info AS ci
INNER JOIN 
   orders AS o ON ci.Id = o.Customer_Id
GROUP BY 
   customer_segment
ORDER BY
   Orders DESC;
   
-- **********************************************************************************************************************************
/*
Question : Percentage of order split

Description: Find the percentage of split of orders by each customer segment for orders that took six days 
to ship (based on Real_Shipping_Days). Sort the result from the highest to the lowest percentage of split orders,
rounding off to one decimal place. The output table should have the following information:
-Customer_segment
-Percentage_order_split

HINT:
Use the orders and customer_info tables from the Supply chain dataset.


*/

SELECT 
   ci.Segment AS customer_segment, 
   ROUND(
        (COUNT(*) * 100.0) / (SELECT COUNT(Order_Id) FROM orders WHERE Real_Shipping_Days = 6), 1)  AS percentage_order_split
 FROM 
    customer_info AS ci
 INNER JOIN 
    orders AS o ON ci.Id = o.Customer_Id
 WHERE 
    Real_Shipping_Days=6
GROUP BY 
    customer_segment
 ORDER BY 
    percentage_order_split DESC;
-- **********************************************************************************************************************************
