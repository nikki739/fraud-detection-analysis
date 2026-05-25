-- =========================================
-- FINANCIAL FRAUD DETECTION ANALYSIS
-- =========================================
-- Tools Used: PostgreSQL, SQL, Power BI
-- Dataset: Kaggle Credit Card Fraud Dataset
-- =========================================

-- =========================================
-- TABLE CREATION
-- =========================================

CREATE TABLE fraud_data (
    Time DOUBLE PRECISION,
    V1 DOUBLE PRECISION,
    V2 DOUBLE PRECISION,
    V3 DOUBLE PRECISION,
    V4 DOUBLE PRECISION,
    V5 DOUBLE PRECISION,
    V6 DOUBLE PRECISION,
    V7 DOUBLE PRECISION,
    V8 DOUBLE PRECISION,
    V9 DOUBLE PRECISION,
    V10 DOUBLE PRECISION,
    V11 DOUBLE PRECISION,
    V12 DOUBLE PRECISION,
    V13 DOUBLE PRECISION,
    V14 DOUBLE PRECISION,
    V15 DOUBLE PRECISION,
    V16 DOUBLE PRECISION,
    V17 DOUBLE PRECISION,
    V18 DOUBLE PRECISION,
    V19 DOUBLE PRECISION,
    V20 DOUBLE PRECISION,
    V21 DOUBLE PRECISION,
    V22 DOUBLE PRECISION,
    V23 DOUBLE PRECISION,
    V24 DOUBLE PRECISION,
    V25 DOUBLE PRECISION,
    V26 DOUBLE PRECISION,
    V27 DOUBLE PRECISION,
    V28 DOUBLE PRECISION,
    Amount DOUBLE PRECISION,
    Class INTEGER
);

-- =========================================
-- EXPLORATORY DATA ANALYSIS (EDA)
-- =========================================

-- Count total transactions
SELECT COUNT(*) AS total_rows
FROM fraud_data;

-- Preview dataset
SELECT *
FROM fraud_data
LIMIT 5;

-- Fraud vs Legitmate Transactions
SELECT
    Class,
    COUNT(*) AS transaction_count
FROM fraud_data
GROUP BY Class;

-- Overall Fraud percentage
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN Class = 1 THEN 1 ELSE 0 END) / COUNT(*),4) AS fraud_percentage
FROM fraud_data;

-- Transaction Amount Statistics
SELECT
    MIN(Amount) AS min_amount,
    MAX(Amount) AS max_amount,
    AVG(Amount) AS avg_amount
FROM fraud_data;

-- Null Values check
SELECT *
FROM fraud_data
WHERE V1 IS NULL;

-- Duplicate Record Check
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (
        ROW(Time, V1, V2, V3, V4, V5, V6, V7, V8, V9,
            V10, V11, V12, V13, V14, V15, V16, V17,
            V18, V19, V20, V21, V22, V23, V24, V25,
            V26, V27, V28, Amount, Class)
    )) AS distinct_rows
FROM fraud_data;

-- =========================================
-- FEATURE ENGINEERING
-- =========================================

-- Creating hour of day Feature
SELECT
    Time,
    (FLOOR(Time / 3600):: INT % 24) AS hour_of_day
FROM fraud_data
LIMIT 10;

-- Creating Transaction Amount Buckets
SELECT
    Amount,
    CASE
        WHEN Amount < 50 THEN 'Small'
        WHEN Amount BETWEEN 50 AND 500 THEN 'Medium'
        ELSE 'Large'
    END AS amount_bucket
FROM fraud_data
LIMIT 20;

-- Creating Readable Transaction Labels
SELECT
    Class,
    CASE
        WHEN Class = 1 THEN 'Fraud'
        ELSE 'Legitimate'
    END AS transaction_type
FROM fraud_data
LIMIT 10;

-- =========================================
-- CREATE CLEANED ANALYTICS TABLE
-- =========================================

CREATE TABLE fraud_cleaned AS
SELECT DISTINCT
    *,
    
    -- converting transaction seconds into hour of day
    (FLOOR(Time / 3600)::INT % 24) AS hour_of_day,
    
    -- categorizing transaction sizes
    CASE
        WHEN Amount < 50 THEN 'Small'
        WHEN Amount BETWEEN 50 AND 500 THEN 'Medium'
        ELSE 'Large'
    END AS amount_bucket,
    
    -- creating readable fraud labels
    CASE
        WHEN Class = 1 THEN 'Fraud'
        ELSE 'Legitimate'
    END AS transaction_type
FROM fraud_data;

-- Verifying final row count
SELECT COUNT(*)
FROM fraud_cleaned;

-- Validating Hour Range
SELECT
    MIN(hour_of_day),
    MAX(hour_of_day)
FROM fraud_cleaned;

-- Amount Bucket Distribution
SELECT
    amount_bucket,
    COUNT(*) AS total_transactions
FROM fraud_cleaned
GROUP BY amount_bucket;

-- =========================================
-- ADVANCED FRAUD ANALYSIS
-- =========================================

-- Fraud Rate by Hour of Day
SELECT
    hour_of_day,
    COUNT(*) AS total_transactions,
    SUM(Class) AS fraud_count,
    ROUND(
        100.0 * SUM(Class) / COUNT(*),3) AS fraud_rate_pct
FROM fraud_cleaned
GROUP BY hour_of_day
ORDER BY fraud_rate_pct DESC;

-- Running Fraud Total 
SELECT
    Time,
    Amount,
    Class,
    SUM(Class) OVER (ORDER BY Time ROWS UNBOUNDED PRECEDING) AS running_fraud_total
FROM fraud_cleaned
ORDER BY Time
LIMIT 20;

-- High-Risk Transaction Detection
SELECT
    Time,
    Amount,
    Class,
    AVG(Amount) OVER () AS overall_avg_amount,
    CASE
        WHEN Amount > (AVG(Amount) OVER () * 3)
        THEN 'High Risk'
        ELSE 'Normal'
    END AS risk_flag
FROM fraud_cleaned
ORDER BY Amount DESC
LIMIT 20;

-- Comparing Fraud Rates by Risk Group
WITH risk_analysis AS (
    SELECT
        Class,
        CASE
            WHEN Amount > (AVG(Amount) OVER () * 3)
            THEN 'High Risk'
            ELSE 'Normal'
        END AS risk_flag
    FROM fraud_cleaned
)
SELECT
    risk_flag,
    COUNT(*) AS total_transactions,
    SUM(Class) AS fraud_count,
    ROUND(
        100.0 * SUM(Class) / COUNT(*),3) AS fraud_rate_pct
FROM risk_analysis
GROUP BY risk_flag;

-- Transaction Amount Percentile Analysis
WITH percentile_analysis AS (
    SELECT
        Amount,
        Class,
        NTILE(100) OVER (ORDER BY Amount) AS amount_percentile
    FROM fraud_cleaned
)
SELECT
    amount_percentile,
    COUNT(*) AS total_transactions,
    SUM(Class) AS fraud_count,
    ROUND(
        100.0 * SUM(Class) / COUNT(*),3) AS fraud_rate_pct
FROM percentile_analysis
GROUP BY amount_percentile
ORDER BY fraud_rate_pct DESC
LIMIT 10;

-- =========================================
-- EXECUTIVE FRAUD SUMMARY METRICS
-- =========================================

SELECT
    COUNT(*) AS total_transactions,
    SUM(Class) AS total_fraud_transactions,
    ROUND(100.0 * SUM(Class) / COUNT(*),3) AS fraud_percentage,
    ROUND(SUM(
            CASE
                WHEN Class = 1 THEN Amount
                ELSE 0
            END ):: numeric,2) AS total_fraud_amount,
    ROUND(AVG(
            CASE
                WHEN Class = 1 THEN Amount
            END):: numeric,2) AS avg_fraud_amount
FROM fraud_cleaned;

-- =========================================
-- EXPORT CLEANED DATA FOR POWER BI
-- =========================================

SELECT * FROM fraud_cleaned;