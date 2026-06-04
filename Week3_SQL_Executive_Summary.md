## DECODELABS PHASE 3: SQL DATA ANALYSIS
## FOCUS: Engine Architecture, Aggregations, & Execution Order


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
