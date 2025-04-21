# 🛍️ Sales and Performance Analytics using SQL

This project explores retail sales, customer behavior, product demand, and operational insights using SQL. It aims to help stakeholders optimize inventory, maximize revenue, and better understand their market.

---

## 📌 Overview

- **Objective:** Analyze franchise sales data to identify high-performing products, seasons, and customer segments.
- **Data Sources:** `sale_register`, `item_master`, `order_summary`
- **Tools Used:** MySQL

---

## 🔍 Insights Summary

### 🔸 Sales & Performance Analysis

1. **Top 10 Franchises by Revenue**
   - Identified high-value franchises based on `(MRP - Discounts) * Quantity`
   - **Action:** Reward loyal customers with incentives or loyalty programs

2. **Autumn/Winter Product Demand**
   - Aggregated product sales in Autumn/Winter season
   - **Action:** Forecast demand for seasonal items

3. **Top Profit Generating Products**
   - Products contributing highest gross profit via `dealer_costprice`
   - **Action:** Prioritize these items in marketing

4. **Best-selling Products**
   - Top 10 products based on total quantity sold
   - **Action:** Stock and promote high-demand products

5. **Top 5 Customers by Order Value**
   - High-value customers ranked by total purchase volume
   - **Action:** Engage with personalized promotions

6. **Most Demanded Product Sizes**
   - Most preferred size per customer using `ROW_NUMBER()`
   - **Action:** Optimize stock availability by size

7. **High Demand, Low Stock Products**
   - Products with large orders but insufficient stock
   - **Action:** Resolve stockouts and improve supply chain response

8. **MRP vs Dealer Cost Analysis**
   - Dealer margins and potential profitability across franchises
   - **Action:** Evaluate pricing strategies

9. **Dealer Discount Impact**
   - Assesses how discounts correlate with sales volumes
   - **Action:** Calibrate discount thresholds for ROI

---

### 🔸 Order Analysis

10. **Revenue by Order Type**
    - Bulk vs Individual vs Wholesale orders
    - **Action:** Focus on high-revenue order channels

11. **Highest Average Order Price Range**
    - Order value brackets and customer groups
    - **Action:** Create price-based customer segments

12. **Top-Selling Commodity Types**
    - Commodities ranked by revenue
    - **Action:** Prioritize stocking of top performers

13. **Delivery Fulfillment Rate**
    - % of orders fully delivered vs ordered
    - **Action:** Minimize partial deliveries

14. **Highest Pending Orders by Product**
    - Pending quantities by product type
    - **Action:** Optimize fulfillment and reduce backlogs

15. **Monthly Revenue Trends**
    - Monthly fluctuations in total revenue
    - **Action:** Plan campaigns and stock ahead of peak months

---

### 🔸 Seasonal & Catalog Trends

16. **Top Performing Seasons**
    - Season-based revenue ranking (Summer, Winter, etc.)
    - **Action:** Launch seasonal promotions accordingly

---

### 🔸 Customer Behavior

17. **Most Frequent Franchise Buyers**
    - Frequency of orders by customer
    - **Action:** Recognize and incentivize frequent buyers

18. **Top Customer-Preferred Colors**
    - Colors with the highest sales volume
    - **Action:** Tailor catalog and visuals to popular preferences

---

## ✅ How to Use

1. Clone the repository
2. Load your data into MySQL
3. Run the queries from `sales_performance_analysis.sql`
4. Visualize and interpret the results

---

## 💡 Business Use Cases

- Inventory Planning & Procurement
- Personalized Customer Offers
- Seasonal Promotion Strategy
- Supply Chain Optimization
- Revenue Forecasting & Pricing

---

## 🔧 Technologies

- **Database:** MySQL
- **Tools:** MySQL Workbench / DBVisualizer

---

## 🙌 Acknowledgments

Big thanks to the fictional dataset creators and the SQL community for guiding performance-focused analysis techniques.

---

## 📬 Let's Connect

- 📧 Email: prasenjit8841@gmail.com  
- 💼 LinkedIn: https://www.linkedin.com/in/prasenjitsaha8841/
---

⭐ **If you found this project useful, please give it a star!**




