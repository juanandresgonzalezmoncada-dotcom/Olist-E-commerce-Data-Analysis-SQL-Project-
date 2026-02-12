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
