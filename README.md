# Financial Fraud Detection Analysis

## Project Overview

This project analyzes financial transaction data to identify fraud patterns, transaction behavior, and operational risk trends using PostgreSQL and Power BI.

The project focuses on:
- Fraud transaction analysis
- Time-based fraud detection
- Risk analysis
- Feature engineering
- Interactive dashboard reporting

---

# Dashboard Preview

<img width="1423" height="800" alt="dashboard_preview" src="https://github.com/user-attachments/assets/e2d5c925-f5e5-4ed6-9607-2c19fd1d5580" />


---

# Business Problem

Financial fraud causes major financial and operational losses for organizations. Detecting suspicious transaction behavior is critical for fraud prevention and risk management.

This project aims to:
- Analyze fraud occurrence patterns
- Identify high-risk transaction behavior
- Detect operational fraud trends
- Build an interactive fraud monitoring dashboard

---

# Tools & Technologies

- PostgreSQL
- SQL
- Power BI
- DAX
- GitHub

---

# Dataset

Dataset Used:
- Kaggle Credit Card Fraud Detection Dataset

Dataset Characteristics:
- 283K+ financial transactions
- Highly imbalanced fraud distribution
- PCA-transformed anonymized variables (V1–V28)

Note: Dataset and PBIX files were excluded from the repository due to file size limitations.

---

# Project Workflow

## 1. Data Import & Database Setup
- Imported CSV dataset into PostgreSQL
- Created structured fraud transaction table
- Validated schema and data integrity

## 2. Data Cleaning
- Checked for null values
- Identified and removed duplicate records
- Created analytics-ready cleaned dataset

## 3. Feature Engineering
Created:
- `hour_of_day`
- `amount_bucket`
- `transaction_type`

## 4. SQL Analysis
Performed:
- Fraud rate analysis
- Window function analysis
- Percentile segmentation
- High-risk transaction detection
- Fraud concentration analysis

## 5. Dashboard Development
Built an interactive Power BI dashboard featuring:
- KPI cards
- Fraud trend analysis
- Transaction behavior visuals
- Interactive slicers
- Executive insights

---

# Key Insights

- Fraud activity peaked between 2 AM – 4 AM
- Small and medium transactions dominated fraud activity
- Overall fraud rate remained below 0.2%
- High-risk transactions showed elevated fraud concentration
- Duplicate records impacted fraud metrics and were removed during cleaning

---

# SQL Concepts Used

- Aggregations
- CASE Statements
- Window Functions
- NTILE()
- CTEs
- Feature Engineering
- Data Cleaning
- Duplicate Validation

---

# Power BI Features

- KPI Cards
- DAX Measures
- Donut Charts
- Column Charts
- Interactive Slicers
- Dashboard Formatting

---

# Repository Files

- `fraud_analysis.sql`
- `dashboard_preview.png`
- `README.md`

---

# How to Run the Project

1. Download the dataset from Kaggle
2. Import the dataset into PostgreSQL
3. Run `fraud_analysis.sql`
4. Export cleaned dataset
5. Open dashboard in Power BI
6. Refresh data if required

---

# Conclusion

This project demonstrates an end-to-end data analytics workflow involving:
- SQL analysis
- Fraud risk analysis
- Data cleaning
- Feature engineering
- Business intelligence reporting
- Interactive dashboard development

The project provides actionable insights into financial fraud behavior using PostgreSQL and Power BI.
