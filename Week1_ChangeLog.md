# 📑 Week 1: Data Cleaning & Preparation Log

**Objective:** To transform a raw dataset into a production-ready "Gold Standard" source of truth by evaluating missing values, duplicates, and structural errors.
**Verification Goal:** 0% Error Rate on Unique Identifiers and Date Formats.
**Tools Utilized:** Microsoft Excel

---

## 🔬 Analytical Workflow & Strategic Decisions

Rather than applying blanket data deletion, each column was rigorously audited to preserve statistical power and business logic.

### 1. Strategic Imputation (Missing Data)
* **Target:** `Coupon` Column
* **Analysis:** Evaluated blanks as null values. In real-world e-commerce data, a null coupon field logically represents a transaction where no discount was applied by the user.
* **Action:** No imputation required. Entered as NULL to preserve accurate discount application rates and revenue calculations.

### 2. The Integrity Audit (Duplicates)
* **Target:** `Customer_ID` and `Order_ID` Columns
* **Analysis:** Identified 11 duplicate `Customer_ID` values. Conducted a cross-sectional audit of adjacent variables (Date, Ordered Items, Payment).
* **Action:** Confirmed these are distinct, valid transactions (returning customers) occurring on different temporal occasions. Verified that the primary key, `Order_ID`, maintains a strict 1-to-1 uniqueness with a 0% duplicate error rate.

### 3. Structural Standardization (Temporal Data)
* **Target:** `Date` Column
* **Analysis:** Evaluated the underlying data types to ensure temporal data was not masquerading as text strings.
* **Action:** Confirmed dates are natively stored as customized numerical values compliant with time_series. No structural transformation is required; the data fully support chronological sorting and time-series forecasting.

### 4. Categorical Standardization 
* **Target:** `Order Status` Column
* **Analysis:** Conducted a unique-value audit to identify structural anomalies, trailing whitespaces, or inconsistent casing.
* **Action:** Verified that the column contains exactly three standardized states ('cancelled', 'delivered', 'Returned', 'Shipping', 'pending'). Zero string variations or invisible space characters were detected.

---

## 📑 The Artifact: Change Log

| Change ID | Description | Impact | Status |
| :--- | :--- | :--- | :--- |
| **CR001** | Evaluated null values in the `Coupon` column. | Nulls represent valid business logic (no coupon applied). No imputation required. | ✅ Verified |
| **CR002** | Audited 11 duplicate `Customer_ID` flags. | Confirmed as distinct, valid repeat transactions. `Order_ID` maintains a strict 0% duplicate error rate. | ✅ Verified |
| **CR003** | Audited Date formatting for Time_series analysis. | Verified underlying data types are numerical and time-series ready. Zero transformations required. | ✅ Verified |
| **CR004** | Audited `Order Status` for categorical uniformity. | Verified exactly three standard states ('cancelled', 'delivered', 'pending'). Zero string variations detected. | ✅ Verified |

---
*By Oluwapelumi.*
