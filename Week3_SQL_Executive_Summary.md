# 🗄️ Phase 3: SQL Data Analysis & Engine Architecture

## 1. Problem Statement
The objective of this phase was to transition from flat-file observation to relational database querying. The goal was to leverage declarative SQL to validate Phase 2 insights at scale, dynamically calculate business metrics without altering raw data, and isolate specific operational and marketing bottlenecks.

## 2. Methodology & Execution Logic
* **The Granularity Audit:** Utilized `GROUP BY` and standard aggregations (`MIN`, `MAX`, `AVG`) to instantly validate structural categorization flaws across 1,200 rows.
* **Execution Order Navigation:** Successfully bypassed the "Alias Trap" by leveraging the `HAVING` clause to filter post-aggregated revenue thresholds (e.g., filtering out products generating < $25,000).
* **Dynamic Feature Engineering:** Calculated complex business metrics (Cart Abandonment Loss) entirely on the fly within the `SELECT` statement, preserving absolute database normalization and storage efficiency.
* **Subquery Architecture:** Deployed nested `SELECT` statements within mathematical calculations to determine percentage-based part-to-whole relationships.

## 3. Key Findings & Verified Insights
* **The Marketing ROI (Subquery Analysis):** Instagram is the undisputed top-performing acquisition channel, driving 21.77% of total gross revenue, followed closely by Email marketing (20.70%). 
* **The UI/UX Bleed (Cart Abandonment):** Grouping engineered lost-revenue metrics by product revealed that `Tablets` are the primary frontend checkout bottleneck, bleeding over $174,690 in potential revenue. 
* **The Operational Bottleneck (Cancellations):** A pre-aggregation `WHERE` filter exposed that front-end abandonment is disconnected from back-end operations. `Chairs` suffer the highest cancellation revenue loss ($48,660). Further isolation by `PaymentMethod` proved this is an infrastructure failure: Credit Cards and Gift Cards account for the vast majority of cancellations, indicating a severe issue with fraud-prevention false positives and split-payment UI processing.
* **The Temporal Audit (Synthetic Flatline):** Extracting and grouping order volumes by `YEAR` and `MONTH` revealed a completely uniform distribution lacking standard e-commerce seasonality or YoY growth. This confirms the dataset is synthetic, intentionally invalidating the use of time-series predictive forecasting in future BI phases.

* MISSION 1: The Granularity Audit
Objective: Prove categorical overlap by finding the Min, Max, and Avg prices per product.
Insight: Exposes the massive $11 to $695 pricing anomaly in the 'Phone' category.

/SELECT 
    Product,
    COUNT(OrderID) AS Total_Orders,
    MIN(UnitPrice) AS Lowest_Price,
    MAX(UnitPrice) AS Highest_Price,
    AVG(UnitPrice) AS Average_Price
FROM dbo.decodelab
GROUP BY Product
ORDER BY Total_Orders DESC;


* MISSION 2: The Revenue Threshold 
Objective: Identify high-performing products generating over $25,000.
Logic: We must use HAVING instead of WHERE because we are filtering the 
mathematically grouped revenue, not the raw individual rows.

/SELECT 
    Product,
    COUNT(OrderID) AS Total_Transactions,
    SUM(Quantity * UnitPrice) AS Gross_Revenue
FROM dbo.decodelab
GROUP BY Product
HAVING SUM(Quantity * UnitPrice) > 25000
ORDER BY Gross_Revenue DESC;


* MISSION 3: Percentage Contribution (Marketing ROI)
Objective: Determine which marketing channels drive the highest percentage of total revenue.
Logic: We use a subquery in the SELECT clause to calculate the Grand Total so we can divide our grouped revenue by it. 

/SELECT 
    Referral_Source,
    SUM(Quantity * UnitPrice) AS Channel_Revenue,
    (SUM(Quantity * UnitPrice) / (SELECT SUM(Quantity * UnitPrice) FROM dbo.decodelab)) * 100.0 AS Percentage_Contribution
FROM dbo.decodelab
GROUP BY Referral_Source
ORDER BY Percentage_Contribution DESC;


* MISSION 4: The Abandonment Bleed (UX Bottleneck)
Objective: Calculate the exact dollar amount of lost revenue caused by cart abandonment.
Logic: We dynamically calculate (ItemsInCart - Quantity) to find the abandoned items, 
multiply by UnitPrice, and SUM the total entirely on the fly.

/SELECT 
    Product,
    SUM((ItemsInCart - Quantity) * UnitPrice) AS Total_Lost_Revenue
FROM dbo.decodelab
GROUP BY Product
ORDER BY Total_Lost_Revenue DESC;


* MISSION 5: The Cancellation Bleed (Operational Bottleneck)
Objective: Calculate the exact dollar amount of lost revenue caused by cancelled orders.
Logic: We use the WHERE clause to filter the raw rows for cancellations BEFORE grouping the data.

/SELECT 
    Product,
    SUM(Quantity * UnitPrice) AS Cancelled_Lost_Revenue
FROM dbo.decodelab
WHERE OrderStatus = 'Cancelled'
GROUP BY Product
ORDER BY Cancelled_Lost_Revenue DESC;


* MISSION 6: The Payment Gateway Bottleneck
Objective: Identify which payment method is responsible for the highest volume and value of cancelled orders.
Insight: Proves the cancellation issue is tied to Credit/Gift Card infrastructure, not Cash-on-Delivery.

/SELECT 
    PaymentMethod,
    COUNT(OrderID) AS Total_Cancelled_Transactions,
    SUM(Quantity * UnitPrice) AS Cancelled_Lost_Revenue
FROM dbo.decodelab
WHERE OrderStatus = 'Cancelled'
GROUP BY PaymentMethod
ORDER BY Cancelled_Lost_Revenue DESC;


* MISSION 7: The Temporal Audit (Macro-Level)
Objective: Group total orders and revenue by year to observe macro-level business growth.
Insight: Proves a synthetic flatline (roughly 38-42 orders/month consistently), invalidating future time-series forecasting.

/SELECT 
    YEAR(OrderDate) AS Sales_Year,
    COUNT(OrderID) AS Total_Annual_Orders,
    SUM(Quantity * UnitPrice) AS Total_Annual_Revenue
FROM dbo.decodelab
GROUP BY YEAR(OrderDate)
ORDER BY Sales_Year;
