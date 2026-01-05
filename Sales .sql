Select *
From sales_table;

Select distinct Retailer
from sales_table;

Select distinct Count(*) Retailer_ID
from sales_table;

SELECT COUNT(DISTINCT Retailer_ID) AS distinct_retailers
FROM sales_table;

SELECT COUNT(DISTINCT Retailer) AS distinct_retailers
FROM sales_table;

Select *
From sales_table;

Select *
from sales_table
where
 Retailer = walmart;
 
 Select distinct Retailer, Retailer_id
 from sales_table
 ;

Select distinct Retailer
from sales_table;

Select distinct Retailer_id
from sales_table;

Select *
From sales_table
;

--- DATA CLEANING
-- 1. Remove. Duplicates
-- 2. Standardize the data
-- 3. Null Values or Blank Values
-- 4. Remove Any Coulumns



Create Table sales_staging
Like sales_table;

Select *
from sales_staging;

Insert sales_staging
select *
from sales_table;

Select *
from sales_staging;

Select *,
Row_number() Over(
Partition By Retailer, Retailer_ID, Region, State, City, Price_per_unit, units_sold, Total_sales, Operating_profit, Sales_method) AS row_num
from sales_staging;


With duplicate_cte AS
(
Select *,
Row_number() Over(
Partition By Retailer, Retailer_ID, Region, State, City, Price_per_unit, units_sold, Total_sales, Operating_profit, Sales_method) AS row_num
from sales_staging
)
Select *
from duplicate_cte 
where row_num > 1;


Select *
from sales_staging
where Retailer = 'Amazon';

With duplicate_cte AS
(
Select *,
Row_number() Over(
Partition By Retailer, Retailer_ID, Region, State, City, Price_per_unit, units_sold, Total_sales, Operating_profit, Sales_method) AS row_num
from sales_staging
)
Delete
from duplicate_cte 
where row_num > 1;


CREATE TABLE `sales_staging2` (
  `Retailer` varchar(100) DEFAULT NULL,
  `Retailer_ID` bigint DEFAULT NULL,
  `Invoice_Date` date DEFAULT NULL,
  `Region` varchar(50) DEFAULT NULL,
  `State` varchar(50) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `Product` varchar(100) DEFAULT NULL,
  `Price_per_Unit` decimal(10,2) DEFAULT NULL,
  `Units_Sold` int DEFAULT NULL,
  `Total_Sales` decimal(12,2) DEFAULT NULL,
  `Operating_Profit` decimal(12,2) DEFAULT NULL,
  `Sales_Method` varchar(50) DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


Select *
from sales_staging2;

Insert Into sales_staging2
Select *,
Row_number() Over(
Partition By Retailer, Retailer_ID, Region, State, City, Price_per_unit, units_sold, Total_sales, Operating_profit, Sales_method) AS row_num
from sales_staging;


Delete
from sales_staging2
where row_num > 1;

Select distinct Invoice_Date
from sales_staging2;

Select *
from sales_staging2
Where retailer_ID is Null;


Delete
FROM sales_staging2
WHERE Price_per_Unit <= 0 OR Units_Sold <= 0 OR Total_Sales <= 0;

SELECT *
FROM sales_staging2
WHERE ROUND(Price_per_Unit * Units_Sold, 2) <> Total_Sales;

SELECT *
FROM sales_staging2
WHERE Invoice_Date IS NULL OR Invoice_Date > CURDATE();

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS null_state,
  SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS null_city
FROM sales_staging2;

CREATE TABLE sales_cleaned AS
SELECT Retailer, Retailer_ID, Invoice_Date, Region, State, City,
       Product, Price_per_Unit, Units_Sold, Total_Sales, Operating_Profit, Sales_Method
FROM sales_staging2;

Select *
from sales_cleaned;

-- DATA EXPLORATORY ANALYSIS (EDA)

Select Count(*)
From sales_cleaned;

SELECT
  COUNT(DISTINCT Retailer) AS distinct_retailers,
  COUNT(DISTINCT Retailer_ID) AS distinct_retailer_ids,
  COUNT(DISTINCT Product) AS distinct_products,
  COUNT(DISTINCT Region) AS distinct_regions,
  COUNT(DISTINCT Sales_Method) AS distinct_sales_methods
FROM sales_cleaned;


SELECT
  SUM(Total_Sales) AS total_revenue,
  SUM(Operating_Profit) AS total_operating_profit,
  AVG(Price_per_Unit) AS avg_price_per_unit,
  AVG(Units_Sold) AS avg_units_sold,
  STDDEV_POP(Price_per_Unit) AS sd_price,
  STDDEV_POP(Units_Sold) AS sd_units
FROM sales_cleaned;

-- Top 10 Products by revenue

SELECT Product, COUNT(*) AS tx_count, SUM(Total_Sales) AS revenue, SUM(Operating_Profit) AS profit
FROM sales_cleaned
GROUP BY Product
ORDER BY revenue DESC
LIMIT 10;

--- Top 10 Retailers by revenue

SELECT Retailer, Retailer_ID, COUNT(*) AS tx_count, SUM(Total_Sales) AS revenue, SUM(Operating_Profit) AS profit
FROM sales_cleaned
GROUP BY Retailer, Retailer_ID
ORDER BY revenue DESC
LIMIT 10;

-- Top 10 Regions by revenue
SELECT Region, COUNT(*) AS tx_count, SUM(Total_Sales) AS revenue, SUM(Operating_Profit) AS profit
FROM sales_cleaned
GROUP BY Region
ORDER BY revenue DESC
LIMIT 10;

-- Rows where price * units differs from total_sales
SELECT COUNT(*) AS mismatch_count
FROM sales_cleaned
WHERE ROUND(Price_per_Unit * Units_Sold, 2) <> ROUND(Total_Sales,2);

-- Rows where profit is negative

SELECT COUNT(*) AS negative_profit_rows, SUM(Total_Sales) AS revenue_in_negative_profit_rows
FROM sales_cleaned
WHERE Operating_Profit < 0;

--- 

Select *
From sales_cleaned;

UPDATE sales_cleaned
SET Total_Sales = ROUND(Price_per_Unit * Units_Sold, 2)
WHERE ROUND(Price_per_Unit * Units_Sold, 2) <> ROUND(Total_Sales, 2);


SELECT
  ROUND(AVG(Price_per_Unit),2) AS avg_price,
  ROUND(AVG(Units_Sold),2) AS avg_units,
  ROUND(AVG(Total_Sales),2) AS avg_sales,
  ROUND(AVG(Operating_Profit),2) AS avg_profit,
  ROUND(MIN(Price_per_Unit),2) AS min_price,
  ROUND(MAX(Price_per_Unit),2) AS max_price
FROM sales_cleaned;


SELECT 
  COUNT(DISTINCT Retailer) AS unique_retailers,
  COUNT(DISTINCT Product) AS unique_products,
  COUNT(DISTINCT Region) AS unique_regions,
  COUNT(DISTINCT State) AS unique_states,
  COUNT(DISTINCT City) AS unique_cities,
  COUNT(DISTINCT Sales_Method) AS unique_methods
FROM sales_cleaned;

SELECT Retailer, COUNT(*) AS total_transactions
FROM sales_cleaned
GROUP BY Retailer
ORDER BY total_transactions ASC
LIMIT 10 
;


SELECT Product, COUNT(*) AS total_transactions
FROM sales_cleaned
GROUP BY Product
ORDER BY total_transactions DESC
LIMIT 10;

SELECT Sales_Method, COUNT(*) AS total_transactions
FROM sales_cleaned
GROUP BY Sales_Method
ORDER BY total_transactions DESC;

--- Revenue and Profit exploration
SELECT 
  ROUND(SUM(Total_Sales),2) AS total_revenue,
  ROUND(SUM(Operating_Profit),2) AS total_profit,
  ROUND(AVG(Operating_Profit / Total_Sales * 100),2) AS avg_profit_margin_percent
FROM sales_cleaned;

SELECT 
  Region,
  ROUND(SUM(Total_Sales),2) AS total_revenue,
  ROUND(SUM(Operating_Profit),2) AS total_profit,
  ROUND(SUM(Operating_Profit) / SUM(Total_Sales) * 100,2) AS profit_margin_percent
FROM sales_cleaned
GROUP BY Region
ORDER BY total_revenue DESC;

SELECT 
  Sales_Method,
  ROUND(SUM(Total_Sales),2) AS total_revenue,
  ROUND(SUM(Operating_Profit),2) AS total_profit,
  ROUND(SUM(Operating_Profit) / SUM(Total_Sales) * 100,2) AS profit_margin_percent
FROM sales_cleaned
GROUP BY Sales_Method
ORDER BY total_revenue DESC;

SELECT 
  Retailer,
  ROUND(SUM(Total_Sales),2) AS total_revenue,
  ROUND(SUM(Operating_Profit),2) AS total_profit,
  ROUND(SUM(Operating_Profit) / SUM(Total_Sales) * 100,2) AS profit_margin_percent
FROM sales_cleaned
GROUP BY Retailer
ORDER BY total_revenue DESC
LIMIT 10;

-- Time trend Analysis 

SELECT 
  DATE_FORMAT(Invoice_Date, '%Y-%m') AS month,
  ROUND(SUM(Total_Sales),2) AS total_revenue,
  ROUND(SUM(Operating_Profit),2) AS total_profit,
  ROUND(SUM(Operating_Profit) / SUM(Total_Sales) * 100,2) AS profit_margin_percent
FROM sales_cleaned
GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
ORDER BY month;

Select *
from sales_cleaned;

-- Top product by revenue and profit

SELECT 
  Product,
  ROUND(SUM(Total_Sales),2) AS total_revenue,
  ROUND(SUM(Operating_Profit),2) AS total_profit,
  ROUND(SUM(Operating_Profit) / SUM(Total_Sales) * 100,2) AS profit_margin_percent
FROM sales_cleaned
GROUP BY Product
ORDER BY total_revenue DESC
LIMIT 10;

-- TOP REGION THAT GENERATE PROFIT
SELECT 
  Region,
  ROUND(SUM(Total_Sales),2) AS total_revenue,
  ROUND(SUM(Operating_Profit),2) AS total_profit,
  ROUND(SUM(Operating_Profit) / SUM(Total_Sales) * 100,2) AS profit_margin_percent
FROM sales_cleaned
GROUP BY Region
ORDER BY total_revenue DESC;

SELECT 
  State,
  ROUND(SUM(Total_Sales),2) AS total_revenue,
  ROUND(SUM(Operating_Profit),2) AS total_profit,
  ROUND(SUM(Operating_Profit) / SUM(Total_Sales) * 100,2) AS profit_margin_percent
FROM sales_cleaned
GROUP BY State
ORDER BY total_revenue DESC
LIMIT 10;

SELECT 
  City,
  ROUND(SUM(Total_Sales),2) AS total_revenue,
  ROUND(SUM(Operating_Profit),2) AS total_profit,
  ROUND(SUM(Operating_Profit) / SUM(Total_Sales) * 100,2) AS profit_margin_percent
FROM sales_cleaned
GROUP BY City
ORDER BY total_revenue DESC
LIMIT 10;

-- BEST PERFOMING SALES METHOD 

SELECT 
  Sales_Method,
  ROUND(SUM(Total_Sales),2) AS total_revenue,
  ROUND(SUM(Operating_Profit),2) AS total_profit,
  ROUND(SUM(Operating_Profit) / SUM(Total_Sales) * 100,2) AS profit_margin_percent
FROM sales_cleaned
GROUP BY Sales_Method
ORDER BY total_revenue DESC;

-- PRODUCT GENERATING HIGHEST AND LOWEST REVENUE

SELECT 
    Region, 
    SUM(Total_Sales) AS Total_Sales
FROM sales_cleaned
GROUP BY Region
ORDER BY Total_Sales DESC;

-- TOP PERFORMING PRODUCT

SELECT 
    Product, 
    SUM(Total_Sales) AS Total_Sales
FROM sales_cleaned
GROUP BY Product
ORDER BY Total_Sales DESC
LIMIT 10;

-- TOP PERFORMING RETAILERS

SELECT 
    Retailer, 
    SUM(Total_Sales) AS Total_Sales
FROM sales_cleaned
GROUP BY Retailer
ORDER BY Total_Sales DESC
LIMIT 10;

-- RETAILER WITH THE HIGHEST SALES
SELECT 
    Retailer, 
    SUM(Total_Sales) AS Total_Sales
FROM sales_cleaned
GROUP BY Retailer
ORDER BY Total_Sales DESC
LIMIT 1;

-- SALES METHOD THAT GENERATE MOST REVENUES

SELECT 
    Sales_Method, 
    SUM(Total_Sales) AS Total_Sales
FROM sales_cleaned
GROUP BY Sales_Method
ORDER BY Total_Sales DESC;

-- REGION WITH HIGHEST OPERATING PROFIT
SELECT 
    Region, 
    SUM(Operating_Profit) AS Total_Operating_Profit
FROM sales_cleaned
GROUP BY Region
ORDER BY Total_Operating_Profit DESC;


-- products With the highest and lowest profit margin (and which have negative margins

SELECT
  Product,
  ROUND(SUM(Total_Sales),2) AS total_revenue,
  ROUND(SUM(Operating_Profit),2) AS total_profit,
  ROUND( SUM(Operating_Profit) / NULLIF(SUM(Total_Sales),0) * 100, 2) AS profit_margin_pct
FROM sales_cleaned
GROUP BY Product
ORDER BY profit_margin_pct DESC;


-- Retailer concentration: retailers/customers that contribute most revenue?

SELECT
  Retailer,
  Retailer_ID,
  SUM(Total_Sales) AS revenue,
  ROUND(SUM(Total_Sales) / (SELECT SUM(Total_Sales) FROM sales_cleaned) * 100, 2) AS revenue_share_pct
FROM sales_cleaned
GROUP BY Retailer, Retailer_ID
ORDER BY revenue DESC
LIMIT 50;

SELECT distinct(Retailer), Retailer_ID
from sales_cleaned;

Select distinct count(retailer), retailer_id
from sales_cleaned;

SELECT 
    Retailer_ID,
    COUNT(DISTINCT Retailer) AS retailer_count
FROM sales_cleaned
GROUP BY Retailer_ID;

SELECT 
  COUNT(DISTINCT Retailer) AS unique_retailers,
  COUNT(DISTINCT Retailer_ID) AS unique_retailer_ids
FROM sales_cleaned;


SELECT 
    Retailer,
    COUNT(DISTINCT Retailer_ID) AS id_count,
    GROUP_CONCAT(DISTINCT Retailer_ID ORDER BY Retailer_ID) AS retailer_ids
FROM sales_cleaned
GROUP BY Retailer
HAVING COUNT(DISTINCT Retailer_ID) > 1;

--- 
SELECT
  Retailer,
  SUM(Total_Sales) AS revenue,
  ROUND(SUM(Total_Sales) / (SELECT SUM(Total_Sales) FROM sales_cleaned) * 100, 2) AS revenue_share_pct
FROM sales_cleaned
GROUP BY Retailer
ORDER BY revenue DESC
LIMIT 50;


WITH monthly AS (
  SELECT
    Product,
    DATE_FORMAT(Invoice_Date, '%Y-%m') AS ym,
    SUM(Units_Sold) AS units
  FROM sales_cleaned
  GROUP BY Product, ym
)
SELECT
  Product,
  ROUND(AVG(units),2) AS mean_units,
  ROUND(STDDEV_POP(units),2) AS sd_units,
  CASE WHEN AVG(units) = 0 THEN NULL ELSE ROUND(STDDEV_POP(units) / AVG(units),4) END AS cv
FROM monthly
GROUP BY Product
ORDER BY cv DESC
LIMIT 50;



