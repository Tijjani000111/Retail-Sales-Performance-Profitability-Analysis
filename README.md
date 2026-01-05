# Retail-Sales-Performance-Profitability-Analysis

## Table of Content 

1. [Project Overview](#project-overview)
2. [Dataset Source and Description](#dataset-source-and-description)
3. [Tools Used](#tools-used)
4. [Data Cleaning and Preparation](#data-cleaning-and-preparation)
5. [Exploration Data Analysis](#exploration-data-analysis)
6. [Data Analysis](#data-analysis) 
7. [Key Metrics Measured](#key-metrics-measured)
8. [Dashboard Overview](#dashboard-overview)
9. [Key Insight and Findings](#key-insight-and-findings) 
10. [Business Implications](#business-implications)
11. [Recommendation](#recommendation)


### Project Overview
This project analyzes retail sales performance across regions, retailers, and product categories to uncover revenue drivers, profitability patterns, and growth opportunities. Using SQL for data preparation and Tableau for visualization, the analysis answers key business questions around where revenue and profit are coming from, what products perform best, and how sales trend over time. The goal is to provide actionable insights that support strategic decisions in product mix optimization, regional focus, and retailer partnerships.

### Dataset Source and Description
Retail Sales Transaction Data: The primary datasets used for this analysis was obtained from Kaggale.
Key data elements include:
- Invoice Date
- Retailer / Retailer ID
- Region / State
- Product Category
- Units Sold
- Total Sales
- Operating Profit


### Tools Used
- SQL (MySQL): Data cleaning, Aggregation and Exploration data analysis.
- Tableau: Data visualization and dashboard development
- Excel: Initial data inspection and validation

### Data Cleaning and Preparation
Data cleaning was performed using SQL to ensure accuracy and consistency before visualization.
Key Cleaning Steps:
- Removed duplicate records
- Nulls or Blanks Values
- Standardized retailer names and product categories
- Validated relationships between Retailer and Retailer ID
- Converted numeric fields to proper data types
- Ensured consistent date formatting for time-series analysis
- Verified revenue and profit calculations

### Exploration Data Analysis
The goal of EDA in this project was to understand the structure, quality, and distribution of the sales data before performing deeper analysis. the EDA steps were 
1. Dataset Structure & Coverage
 - Reviewed number of records, columns, and data types
 - Identified key dimensions: Region, Retailer, Product, Invoice Date
 - Identified key measures: Units Sold, Price per Unit, Total Sales, Operating Profit
2. Data Quality Checks
 - Checked for missing and null values across numeric and categorical fields
 - Identified inconsistencies between Retailer and Retailer ID mappings
3. Descriptive Statistics
Summary statistics for:
 - Total Sales
 - Operating Profit
 - Units Sold
 - Price per Unit
4. Time-Based Exploration
 - Examined sales trends over time (monthly aggregation)
 - Identified seasonality and peak sales periods.

### Data Analysis 
This phase focused on answering business-driven questions using cleaned and validated data.
1. Revenue Performance Analysis
Analyzed total revenue by:
 - Region
 - Retailer
 - Product
 - Identified top-performing and underperforming segments
The SQL code query used for this are
``` SQL
-- Total Revenue by Region
SELECT
    Region,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue
FROM sales_cleaned
GROUP BY Region
ORDER BY Total_Revenue DESC;

-- Total Revenue by Retailer
SELECT
    Retailer,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue
FROM sales_cleaned
GROUP BY Retailer
ORDER BY Total_Revenue DESC;

-- Total Revenue by Product
SELECT
    Product,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue
FROM sales_cleaned
GROUP BY Product
ORDER BY Total_Revenue DESC;

-- Top 5 Products by Revenue
SELECT
    Product,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue
FROM sales_cleaned
GROUP BY Product
ORDER BY Total_Revenue DESC
LIMIT 5;

-- Bottom 5 Products by Revenue
SELECT
    Product,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue
FROM sales_cleaned
GROUP BY Product
ORDER BY Total_Revenue ASC
LIMIT 5;
```
2. Profitability & Margin Analysis
Calculated product-level profit margins using:
 - Operating Profit / Total Sales
The SQL Code Query used is
```
SELECT
    Product,
    ROUND(SUM(Operating_Profit), 2) AS Total_Operating_Profit,
    ROUND(SUM(Total_Sales), 2) AS Total_Revenue,
    ROUND(
        SUM(Operating_Profit) / NULLIF(SUM(Total_Sales), 0),
        4
    ) AS Profit_Margin
FROM sales_cleaned
GROUP BY Product
ORDER BY Profit_Margin DESC;
```
3. Sales Trend Analysis
Analyzed monthly sales trends to assess:
 - Growth patterns
 - Volatility
 - Seasonal behavior
The SQL Code Query used is
```
-- Time trend Analysis 
SELECT 
  DATE_FORMAT(Invoice_Date, '%Y-%m') AS month,
  ROUND(SUM(Total_Sales),2) AS total_revenue,
  ROUND(SUM(Operating_Profit),2) AS total_profit,
  ROUND(SUM(Operating_Profit) / SUM(Total_Sales) * 100,2) AS profit_margin_percent
FROM sales_cleaned
GROUP BY DATE_FORMAT(Invoice_Date, '%Y-%m')
ORDER BY month;
```
### Key Metrics Measured
 - Total Sales
 - Units Sold
 - Operating Profit
 - Profit Margin (%)
 - Monthly Sales Growth
 - Revenue Contribution by Region
 - Revenue Contribution by Retailer
 - Profit by Product Category

### Dashboard Overview
The Tableau dashboard presents a comprehensive view of sales performance:
Dashboard Components:
 - KPI Summary
 - Total Sales: $326.23M
 - Units Sold: 6.77M
 - Operating Profit: $87.15M
 - Revenue by Region
 - Revenue by Retailer
 - Product Profit Margin
 - Profit by State (Map)
 - Monthly Sales Trend
The dashboard is designed for executive-level consumption, with clear KPIs followed by diagnostic breakdowns.
<img width="1229" height="654" alt="Screenshot 2026-01-05 at 10 16 51 PM" src="https://github.com/user-attachments/assets/5ba4c75e-7751-40e7-b1e1-c247c2477953" />

<img width="1229" height="655" alt="Screenshot 2026-01-05 at 10 16 59 PM" src="https://github.com/user-attachments/assets/964d0875-73f5-42ad-9b81-21396501561e" />


### Key Insight and Findings
1. Revenue Concentration by Region
 - The West region generates the highest revenue, significantly outperforming other regions.
 - The Midwest contributes the least revenue, indicating potential underperformance or market saturation.
2. Retailer Performance
 - West Gear and Foot Locker are the top revenue-generating retailers.
 - Revenue drops sharply after the top three retailers, showing high dependency on a small number of partners.
3. Product Profitability
 - Women’s Apparel and Men’s Street Footwear have the highest profit margins.
 - Some high-volume products generate lower margins, suggesting pricing or cost optimization opportunities.
4. Sales Trend Over Time
 - Sales peak mid-year (around July), indicating possible seasonality.
 - A noticeable dip occurs in early Q4, followed by recovery in December.
5. Geographic Profit Distribution
 - States like California and Florida drive a significant portion of operating profit.
 - Profit contribution is uneven across states, highlighting regional performance gaps.

### Business Implications
 - Revenue dependency on a few regions and retailers increases business risk.
 - High-margin products are not always the highest-selling products.
 - Regional underperformance may indicate missed expansion or marketing opportunities.
 - Seasonality should be considered in inventory and promotion planning.

### Recommendation
1. Optimize Product Mix
 - Promote and expand high-margin categories (e.g., Women’s Apparel).
 - Review pricing and cost structures for low-margin, high-volume products.
3. Strengthen Regional Strategy
 - Double down on high-performing regions like the West.
 - Investigate underperforming regions (e.g., Midwest) for growth barriers.
4. Retailer Diversification
 - Reduce reliance on top retailers by strengthening mid-tier retailer partnerships.
 - Use performance benchmarks from top retailers to improve others.
5. Seasonal Planning
 - Align inventory, marketing, and promotions with observed mid-year sales peaks.
 - Prepare targeted campaigns to reduce early Q4 slowdowns.

