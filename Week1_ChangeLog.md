# 📑 Week 1: Data Cleaning, Integrity & Business Logic Log

**Objective:** To transform a raw dataset into a verified, production-ready "Gold Standard" source of truth by evaluating structural anomalies, mathematical integrity, and business logic.
**Dataset Shape:** 1,201 Rows | 14 Columns | 16,814 Total Entries
**Tools Utilized:** Microsoft Excel

---

## 🔬 Analytical Workflow & Strategic Decisions

Rather than applying blanket data deletion, each column was rigorously audited to preserve statistical power, business logic, and mathematical integrity.

### 1. Structural Standardization (0% Error Baseline)
* **Temporal Data:** Evaluated the `Date` column. Confirmed dates are natively stored as customized numerical values (compliant with ISO 8601), fully supporting continuous time-series forecasting.
* **Categorical Uniformity:** Audited `Product` (7 unique), `Payment Method`, `Shipping Address`, `Order Status`, and `Referral Source` (5 unique). Verified strict adherence to standard naming conventions with zero trailing whitespaces.
* **Strategic Imputation:** Identified 310 explicit nulls in the `Coupon` column. Left as NULL without imputation to accurately reflect organic, non-discounted transactions within the e-commerce model.

### 2. Relational Entity & Mathematical Validation
* **The 1-to-Many Customer Relationship:** Identified 11 duplicate `CustomerID` entries. Cross-sectional analysis of timestamps and products confirmed these as distinct, valid repeat transactions. The `OrderID` primary key maintains strict 1-to-1 uniqueness.
* **Revenue Logic:** Cross-verified the `Total Price` column. Verified 100% mathematical alignment (`Total Price` exactly equals `Quantity` × `Unit Price` across all rows).

### 3. Advanced Business Logic Verification
* **Cart-to-Order Conversion:** Conducted a boolean stress test (`Quantity > Items in Cart`) to identify potential frontend tracking failures. Verified 100% logical integrity; zero instances of checkout quantities mathematically exceeding cart sizes.
* **Feature Engineering (Cart Abandonment):** Engineered a new operational metric, calculating `Items in Cart - Quantity = Abandoned_Items`, quantifying partial cart abandonment for future conversion rate analysis.

### 4. Data Granularity Constraints (Critical Finding)
* **The Unit Price Anomaly:** Identified severe price discrepancies for identical product labels (e.g., 'Monitor' ranging from $49 to $611) independent of chronological inflation.
* **Analytical Conclusion:** The `Product` column lacks the SKU-level granularity required for precise pricing models. Broad labels are functioning as umbrella categories. This structural limitation is documented to prevent skewed predictive modeling in future phases.

---

## 📑 The Artifact: Unified Audit Trail

| Change ID | Description | Impact | Status |
| :--- | :--- | :--- | :--- |
| **CR001** | Evaluated null values in the `Coupon` column. | Nulls represent valid logic (no discount). Zero records deleted. | ✅ Verified |
| **CR002** | Audited 11 duplicate `Customer_ID` flags. | Confirmed as distinct repeat transactions. `Order_ID` maintains 0% error rate. | ✅ Verified |
| **CR003** | Audited Date formatting for ISO 8601 compliance. | Verified underlying data types are numerical and time-series ready. | ✅ Verified |
| **CR004** | Categorical uniformity audit (`Order Status`, `Product`, etc.) | Verified standard casing and zero string variations detected. | ✅ Verified |
| **CR005** | Mathematical validation of `Total Price`. | Verified 100% alignment with `Quantity * Unit Price`. | ✅ Verified |
| **CR006** | Cart Logic boolean test (`Quantity <= Cart`). | Verified 100% frontend tracking integrity. | ✅ Verified |
| **CR007** | Feature Engineering: `Abandoned_Items` column created. | Enables quantification of lost potential revenue. | ✅ Deployed |

---
*Audit completed by Oluwapelumi Atanda.*
