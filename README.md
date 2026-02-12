# Olist E-commerce Data Analysis (SQL Project)

End-to-end SQL data analysis project exploring sales trends, customer behavior, and delivery performance using the Olist Brazilian E-commerce dataset.

This project performs a complete data analysis of the Olist e-commerce dataset using SQL.
The objective is to extract business insights related to:

  - Sales trends over time
  - Customer purchasing behavior
  - Delivery performance
  - Top-performing products and categories

The project follows a structured data workflow from raw ingestion to cleaned and derived analytical datasets.

## Project Structure

```
├── data
│   ├── raw/        # Original dataset
│   ├── cleaned/    # Cleaned and normalized tables
│   └── derived/    # Analytical and aggregated datasets
│
├── ERD/
│   └── erd.png     # Entity-Relationship Diagram
│
├── sql/
│   ├── 01_schema.sql
│   ├── 02_load.sql
│   ├── 03_clean.sql
│   ├── 04_constraints.sql
│   ├── 05_views.sql
│   └── analysis.sql
│       ├── revenue.sql
│       ├── customer.sql
│       ├── geography.sql
│       ├── delivery.sql
│       └── products.sql
│
├── notebooks/
│   ├── 01_revenue_analysis.ipynb
│   ├── 02_customer_analysis.ipynb
│   ├── 03_geography_analysis.ipynb
│   ├── 04_delivery_analysis.ipynb
│   └── 05_products_analysis.ipynb
│
└── README.md
```

The project uses a variety of tools and technoogies including:
  - SQL (MariaDB) involving window functions and views for better query readability
  - Python (Pandas, Scipy, Matplotlib)
  - Jupyter Notebooks
  - Git
  - Data modeling (ERD design)

## Business Questions Answered
### 1. How has revenue evolved over time?

* Identified growth and stabilization phases in monthly revenue.
* Distinguished expansion vs maturity periods.

### 2. Is revenue growth driven by higher spending or more orders?

* Decomposed revenue into:
    *   Order volume
    * Average Order Value (AOV)
* Found revenue primarily driven by order frequency.

### 3. Are there structural outliers in revenue behavior?

* Used IQR to evaluate December 2016 anomaly.
* Determined it reflected early platform activity rather than data error.

### 4. What is historic customer lifetime value (LTV)?

* Computed customer-level LTV using delivered payments.
* Identified concentration of revenue among few high-value customers.

### 5. Are high-LTV customers repeat buyers?

* Found many top LTV customers placed only one order.
* Suggests transactional spikes rather than loyalty-driven revenue.

### 6. What is the impact of repeat buyers?

* Repeat customers represent only a small fraction of customer base.
* Repeat customers place smaller orders than customers in general.
* Repeat customers bring larger revenue than regular buyers, despite lower AOV.

### 7. Are there regional purchasing differences?

* Compared revenue and AOV by state.
* Computed correlation between AOV and customer density.
* Observed moderate negative correlation (-0.56), suggesting structural regional differences.

### 8. Which product categories drive revenue?

* Identified top 5 revenue-generating categories.
* Analyzed monthly trends at category level.

## Data Engineering & Cleaning Process
* Separated data into:

    * raw/
    * cleaned/
    * derived/

* Built reusable SQL views for:
    
    * Delivered orders
    * Delivered payments
    * Order–customer relationships

* Resolved:

    * Missing payment records
    * Null timestamps
    * Inconsistent category formatting
    * Windows carriage return (\r) artifacts

* Ensured idempotent SQL scripts
* Aggregated data into analytical tables (monthly revenue, AOV, category revenue, etc.)

## Key Insights

* Revenue growth transitions from rapid expansion (2016–2017) to stabilization (post-2017).
* AOV remains relatively stable over time.
* Revenue variability is largely explained by order frequency.
* December 2016 outlier reflects early-stage platform adoption.
* Top LTV customers are not necessarily repeat customers.
* Delivery delays may negatively influence retention.
* Revenue is highly concentrated in a limited set of product categories.
* Moderate negative correlation between AOV and customer density across states.

## SQL Techniques Demonstrated

* CTEs (Common Table Expressions)
* Window functions (ROW_NUMBER())
* Conditional aggregation (CASE WHEN)
* Cohort-style first-order identification
* Multi-level grouping (category, month, state)
* Subqueries with IN
* Ranking and limiting (Top N categories)
* Robust outlier detection logic (IQR-based selection)
* Correlation-ready aggregation pipelines

## How to Run the Project
### 1. Open the sql/ folder.
### 2. Run SQL scripts in the following order:
* 01_set.sql *– schema creation*
* 02_load.sql *– data uploading*
* 03_clean.sql *– cleaning and normalization*
* 04_constraints.sql *– imposes constraints according to ERD*
* 05_views.sql *– analytical views*
### 3. Open the 06_analysis/ folder and run all scripts inside
### 4. Open the Jupyter notebooks in the notebooks/ folder.

## Future Improvements
* Cohort retention curves (by acquisition month)
* Survival analysis for customer churn
* RFM segmentation
* Seasonality decomposition (STL)
* Customer clustering (k-means)
* Causal analysis of delivery delays on retention
* Contribution margin instead of gross revenue
* Automated dashboard (Power BI / Tableau / Streamlit)
