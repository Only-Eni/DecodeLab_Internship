USE DecodeLabs

SELECT *
FROM dbo.decodelab;

-- MISSION 1: The EDA outliers Audit
-- Objective: Prove categorical overlap by finding the Min, Max, and Avg prices per product.
SELECT 
    Product,
    COUNT(OrderID) AS Total_Orders,
    MIN(UnitPrice) AS Lowest_Price,
    MAX(UnitPrice) AS Highest_Price,
    AVG(UnitPrice) AS Average_Price
FROM dbo.decodelab
GROUP BY Product
ORDER BY Total_Orders DESC;

/* MISSION 2: The Revenue Threshold 
Objective: Identify high-performing products.*/
SELECT 
    Product,
    COUNT(OrderID) AS Total_Transactions,
    SUM(Quantity * UnitPrice) AS Gross_Revenue
FROM dbo.decodelab
GROUP BY Product
HAVING SUM(Quantity * UnitPrice) > 25000
ORDER BY Gross_Revenue DESC;

/* MISSION 3: Percentage Contribution  
(We multiply by 100.0 instead of 100 to prevent SQL from rounding decimals down to zero).
*/
SELECT 
    ReferralSource,
    SUM(Quantity * UnitPrice) AS Channel_Revenue,
    
    -- The Percentage Math (Part / Whole * 100)
    (SUM(Quantity * UnitPrice) / (SELECT SUM(Quantity * UnitPrice) FROM dbo.decodelab)) * 100.0 AS Percentage_Contribution

FROM dbo.decodelab
GROUP BY ReferralSource
ORDER BY Percentage_Contribution DESC;

/* MISSION 4: The lost revenue from Abandoned cart
Objective: Calculate the exact dollar amount of lost revenue caused by cart abandonment, grouped by product.
*/
SELECT 
    Product,
    SUM((ItemsInCart - Quantity) * UnitPrice) AS Total_Lost_Revenue
FROM dbo.decodelab
GROUP BY Product
ORDER BY Total_Lost_Revenue DESC;

/* MISSION 5: The Cancellation of orders
Objective: Calculate the exact dollar amount of lost revenue caused by cancelled orders, grouped by product.
*/
SELECT 
    Product,
    SUM(Quantity * UnitPrice) AS Cancelled_Lost_Revenue
FROM dbo.decodelab
WHERE [OrderStatus] = 'Cancelled'
GROUP BY Product
ORDER BY Cancelled_Lost_Revenue DESC;

/* MISSION 6: The Payment Bottleneck
Objective: Identify which payment method is responsible for the highest volume and value of cancelled orders.
*/
SELECT 
    PaymentMethod,
    COUNT(OrderID) AS Total_Cancelled_Transactions,
    SUM(Quantity * UnitPrice) AS Cancelled_Lost_Revenue
FROM dbo.decodelab
WHERE OrderStatus = 'Cancelled'
GROUP BY PaymentMethod
ORDER BY Cancelled_Lost_Revenue DESC;

/* MISSION 7: The Date Audit
Objective: Audit the timeline to ensure structural integrity before exporting to Power BI.
*/
SELECT 
    YEAR(Date) AS Sales_Year,
    MONTH(Date) AS Sales_Month,
    COUNT(OrderID) AS Total_Orders,
    SUM(Quantity * UnitPrice) AS Monthly_Revenue
FROM dbo.decodelab
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Sales_Year, Sales_Month;

/* MISSION 8: Year-Over-Year (YoY) Trend Analysis
Objective: Group total orders and revenue by year to observe macro-level business growth.
*/
SELECT 
    YEAR(Date) AS Sales_Year,
    COUNT(OrderID) AS Total_Annual_Orders,
    SUM(Quantity * UnitPrice) AS Total_Annual_Revenue
FROM dbo.decodelab
GROUP BY YEAR(Date)
ORDER BY Sales_Year;