create database sql_footwear_project;

use sql_footwear_project;

select * from order_summary;

select * from sale_register;

create table item_master(
ProductCode int,
SEASON_YEAR	text,
MRP	int,
`Sum of SIZE` int,
COLOUR	text,
MC1	text,
MC text,
STYLE text,
RM text,
HEEL text,
SOLE text,
COMMODITY text,
SEASON_CATG text);

ALTER TABLE ITEM_MASTER
RENAME column `Sum of SIZE` to sum_of_size;

ALTER TABLE item_master
RENAME column productcode to product_code;

ALTER TABLE sale_register
RENAME column `ï»¿Product_Code` to product_code;

ALTER TABLE order_summary
RENAME column `ï»¿Product_Code` to product_code;

select* from item_master;

/*Sales and Performance Analysis
Q1.Which Top 10 Franchises generated the highest sales revenue?
o	Tables: Sale Register
o	Compute sales revenue as quantity * (mrp - dealer discount - tax discount)
Insight:Identify top-spending customers and reward them with loyalty programs
or personalized discounts.*/
select custname,floor(sum(dealer_costprice))as Total_Price
from sale_register
group by custname
order by Total_price desc
limit 10;

/*Q2.What is the total sales quantity for each product in Autumn/winter?
o	Tables: Item Master, Sale Register
o	Join on product code to filter sales by season.*/
select i.commodity,sum(s.quantity) as Total_Quantity,i.season_catg
from sale_register s inner join item_master i using(product_code)
where i.season_catg = "Autumn/Winter"
group by i.commodity
order by total_quantity desc;

/*Q3.Which products generate the highest profit margins?"
Insight:Identify the most profitable products and prioritize them in marketing and inventory.*/
select im.mc as Products, 
       floor(SUM(sr.dealer_costprice)) AS Total_profit
FROM sale_register sr JOIN item_master im using(product_code)
GROUP BY Products
ORDER BY total_profit DESC
LIMIT 10;

/*Q4.Which products have the highest sales quantity?"
Insight:Identify the top 10 best-selling products to focus inventory and marketing strategies.*/
SELECT  im.mc,  SUM(sr.quantity) AS total_quantity_sold
FROM sale_register sr JOIN item_master im using(product_code)
GROUP BY im.mc
ORDER BY total_quantity_sold DESC
LIMIT 10;

/*Q5.What are the top 5 customers based on order value?
o	Tables: Order Summary
o	Aggregate order value by customer name and sort in descending order.*/
select s.custname,sum(o.rate*o.order_qty) as Total_Orders
from sale_register s inner join order_summary o using(product_code)
group by s.custname
order by total_orders desc
limit 5;

/*Q6.Which size of a product has the highest demand?
o	Tables: Order Summary, Sale Register
o	Aggregate order quantity or quantity by size.*/
WITH CTE AS (
    SELECT Sizecode,Custname,SUM(Quantity) AS Total_Quantity_Sold,
	ROW_NUMBER() OVER (PARTITION BY sizecode ORDER BY SUM(Quantity) DESC) AS `Rank`
    FROM sale_register
    GROUP BY 1,2
)
SELECT Sizecode, Custname,Total_Quantity_Sold
FROM CTE
WHERE `Rank` = 1
order by Total_Quantity_Sold desc;

/*Q7.Which products have high orders but low availability?"
Insight:Helps in avoiding stockouts by understanding which products are in high demand but low supply.*/
SELECT im.style as Products, 
	SUM(os.order_qty) AS total_ordered, 
	count(im.sum_of_size) AS available_stock,
    round(1 - (count(im.sum_of_size)/SUM(os.order_qty)),2) as Stock_Shortage_Percentage
FROM item_master im inner JOIN order_summary os  using(product_code)
where im.style <> "N/A" 
GROUP BY Products
HAVING total_ordered > available_stock and total_ordered > 100
ORDER BY total_ordered DESC;

/*Q8.How does the dealer cost price compare with the MRP across all sales?
o	Tables: Sale Register
o	Compute the difference between mrp and dealer cost price.*/
select custname,
	floor(sum(total_mrp)) as Total_Mrp,
	floor(sum(dealer_costprice)) as Total_Dealer_Cost_Price,
	concat(floor((sum(total_mrp)-sum(dealer_costprice))/sum(total_mrp)*100)," %") as Profit_Margin_percentage
from sale_register
group by custname
order by Total_Dealer_Cost_Price desc;

/*Q9.How does dealer discount affect total revenue?
Insight:Understand if higher discounts lead to more sales volume or lower profit margins.*/
SELECT custname,
	sum(dealer_discount) as Total_Dealer_Discount, 
    COUNT(product_code) AS total_orders, 
    SUM(total_mrp) AS total_revenue
FROM sale_register
GROUP BY custname
ORDER BY total_revenue DESC;

/*Order Analysis
Q10.Which order type contributes the most to revenue?"
Insight:Identify whether bulk orders, individual orders, or wholesale orders contribute the most revenue*/
SELECT os.order_type, SUM(os.Bill_Qty*rate) AS total_revenue
FROM order_summary os
GROUP BY os.order_type
ORDER BY total_revenue DESC;

/*Q11.Which price range is has the highest average order?
o	Tables: Order Summary
o	Calculate the average order value grouped by customer name.*/
select 
	order_value_range,
    count(*) as Total_Customers,
	sum(Total_Orders) as Total_Orders,
	sum(Total_Revenue) as Total_Revenue,
	floor(avg(Avg_Order_Value))as Avg_Order_Value_Per_Group
from(
select 
	custname,
		sum(order_qty) as Total_Orders,
		sum(rate * Order_qty) as Total_Revenue,
		floor(sum(rate * Order_qty)/sum(order_qty))as Avg_Order_Value,
		case
			when floor(sum(rate * Order_qty)/sum(order_qty)) < 500 then "199 - 499"
			when floor(sum(rate * Order_qty)/sum(order_qty)) between 500 and 999 then "500 - 999"
			when floor(sum(rate * Order_qty)/sum(order_qty)) between 1000 and 1499 then "1000 - 1499"
		end as Order_Value_Range
from order_summary
group by custname
)as sub
group by order_value_range
order by Order_Value_range;


/*Q12.Which commodity types contribute the most to sales volume?
o	Tables: Order Summary
o	Aggregate order quantity by order type.*/
select comodity,
	sum(rate*order_qty) as Total_Revenue
from order_summary
group by comodity
order by total_revenue desc;

/*Q13.What is the percentage of orders fully delivered (bill quantity = order quantity)?
o	Tables: Order Summary
o	Count the number of fully delivered orders and divide by total orders.*/
select comodity,
	sum(order_qty) as Total_Orders,
    sum(bill_qty)as Deleivered_Orders,
    concat(floor((sum(bill_qty)/sum(order_qty))*100)," %") as Delivery_Rate_Percent
from order_summary
group by comodity
order by Delivery_Rate_Percent desc;

/*Q14.Which products have the highest orders pending ?"
Insight:Identify products with high pending quantities to optimize 
supply chain and order fulfillment*/
SELECT im.mc as Product_Type, 
	sum(os.order_qty) as Total_Orders,
	SUM(os.pending_qty) AS total_pending_qty
FROM order_summary os JOIN item_master im using(product_code)
GROUP BY Product_Type
ORDER BY total_pending_qty DESC;

/*Q15.How do orders fluctuate by month?
Insight:Identify peak sales months for better inventory planning and marketing efforts.*/
SELECT date_format(str_to_date(sr.order_date,"%Y-%m-%d"),"%M") AS Order_month, 
    SUM(sr.total_mrp) AS total_revenue
FROM sale_register sr
GROUP BY Order_month
ORDER BY total_revenue desc ;

/*Seasonal and Catalog Trends
Q16.What are the best-performing seasons in terms of sales revenue?
o	Tables: Item Master, Sale Register
o	Join on product code and group sales by season.
Insight:Determine which seasons (e.g., Autumn, Winter, Summer, etc.) drive 
the most revenue and plan seasonal discounts or marketing.*/
select i.season_catg,
	floor(sum(s.dealer_costprice)) as Total_Revenue
from sale_register s inner join item_master i using(product_code)
group by i.SEASON_CATG
order by total_revenue desc;

/*Customer Behavior
Q17.Which Franchise purchases the most frequently?
o	Tables: Sale Register
o	Count distinct order date occurrences grouped by customer name.*/
select custname,count(order_date) as Order_frequency
from sale_register
group by custname
order by Order_frequency desc;

/*Q18.Which colors are the most preferred by customers?"
Insight:Helps in deciding which colors to stock more based on customer preferences.*/
SELECT im.colour, SUM(sr.quantity) AS total_sold
FROM sale_register sr
JOIN item_master im ON sr.product_code = im.product_code
GROUP BY im.colour
ORDER BY total_sold DESC;




    




























