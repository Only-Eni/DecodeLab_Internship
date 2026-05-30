# 📊 Phase 2: Exploratory Data Analysis (EDA) & Executive Summary

## 1. Problem Statement
The objective of this exploratory phase was to uncover the underlying shape and distribution of e-commerce transactions, isolate structural anomalies, and identify the primary behavioral drivers of high-value transactions.

## 2. Methodology
* **Descriptive Statistics:** Generated a Five-Number Summary to locate the true center of gravity (Median) for continuous variables, avoiding Mean-distortion caused by skewed sales data.
* **Outlier Detection:** Deployed the Interquartile Range (IQR) method (Upper Bound = Q3 + 1.5 * IQR) to separate system noise from valid, high-value behavioral signals.
* **Feature Engineering:** Engineered an `Abandoned_Items` metric (`Items in Cart` - `Quantity`) to quantify frontend checkout friction.

## 3. Key Findings & Verified Insights
* **The Granularity Constraint (Structural):** A pivot-based Min/Max analysis revealed severe categorical overlap. For example, the `Phone` category contains unit prices ranging from $11.39 to $695.10, indicating mixed segments within a single category.
* **The Bulk-Buyer Signal (Behavioral):** The IQR method established a normal revenue ceiling of $3,330.41. Filtering for outliers above this threshold isolated 8 VIP transactions. 100% of these maximum-revenue transactions involved 5+ unit quantities.
* **Cart Abandonment (Operational):** Boolean stress-testing verified the mathematical integrity of the cart logic (0 instances of checkout > cart size), successfully validating the engineered abandonment metric.

## 4. Business Recommendations
* **Implement B2B Volume Pricing:** Since 5-unit bulk orders drive the absolute highest revenue spikes, the marketing team should design targeted "Volume Discount" or B2B tier structures to incentivize larger order sizes.
* **Require SKU-Level Granularity:** Halt any predictive pricing models based on current broad categories. The data engineering team must append specific `Product_ID` or `SKU` columns to separate accessories from flagship devices.
* **Deploy Abandonment Retargeting:** Utilize the newly engineered `Abandoned_Items` column to trigger automated, segmented email campaigns specifically for users leaving high-margin items in their carts.
