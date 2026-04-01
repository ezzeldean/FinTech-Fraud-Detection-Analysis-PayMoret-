-- =========================================================================
-- FRAUD DETECTION ANALYSIS PIPELINE
-- Goal: Identify smurfing behavior, profile fraudsters, and detect bust-out fraud.
-- =========================================================================

USE paymoret;

-- =========================================================================
-- 1. DAY-LEVEL SMURFING ANALYSIS (Detailed View)
-- Flagging specific days where an account had more than 5 transactions
-- =========================================================================
WITH fraud AS (
    SELECT account_id, date, count(trans_id) AS total_trans_same_day, SUM(amount) AS fraud_amount
    FROM trans
    GROUP BY account_id, date
    HAVING count(trans_id) > 5
)
SELECT f.account_id, f.date, d.client_id, c.gender, c.Birth_Date, f.total_trans_same_day, d.type, f.fraud_amount
FROM fraud f
JOIN disp d ON f.account_id = d.account_id
JOIN client c ON d.client_id = c.client_id
WHERE d.type = 'OWNER'
ORDER BY f.fraud_amount DESC, f.total_trans_same_day DESC;

-- =========================================================================
-- 2. TOTAL RISK ASSESSMENT (Aggregated Account Level)
-- Summarizing the total suspicious activity and amounts per client over all days
-- =========================================================================
WITH fraud AS (
    SELECT account_id, date, count(trans_id) AS total_trans_same_day, SUM(amount) AS fraud_amount
    FROM trans
    GROUP BY account_id, date
    HAVING count(trans_id) > 5
)
SELECT f.account_id, d.client_id, c.gender, c.Birth_Date, SUM(total_trans_same_day) AS total_trans, d.type, SUM(f.fraud_amount) AS total_fraud_amount
FROM fraud f
JOIN disp d ON f.account_id = d.account_id
JOIN client c ON d.client_id = c.client_id
WHERE d.type = 'OWNER'
GROUP BY f.account_id, d.client_id, c.gender, c.Birth_Date, d.type
ORDER BY total_fraud_amount DESC, total_trans DESC;

-- =========================================================================
-- 3. GHOST ACCOUNTS DETECTION (Insider Threat Investigation)
-- Looking for highly active suspicious accounts that have no associated client data
-- =========================================================================
WITH fraud AS (
    SELECT account_id, date, count(trans_id) AS total_trans_same_day, SUM(amount) AS fraud_amount
    FROM trans
    GROUP BY account_id, date
    HAVING count(trans_id) > 5
)
SELECT f.account_id, SUM(f.total_trans_same_day) AS total_trans, SUM(f.fraud_amount) AS total_amount
FROM fraud f
LEFT JOIN disp d ON f.account_id = d.account_id
WHERE d.client_id IS NULL
GROUP BY f.account_id
ORDER BY total_amount DESC;

-- =========================================================================
-- 4. DEMOGRAPHIC PROFILING: GENDER DISTRIBUTION
-- Analyzing the gender breakdown of the identified fraud suspects
-- =========================================================================
WITH fraud AS (
    SELECT t.account_id, c.client_id, c.gender
    FROM trans t
    JOIN disp d ON t.account_id = d.account_id
    JOIN client c ON d.client_id = c.client_id
    WHERE d.type = 'OWNER'
    GROUP BY t.account_id, t.date, c.client_id, c.gender
    HAVING count(t.trans_id) > 5
)
SELECT gender, COUNT(DISTINCT client_id) AS suspect_count
FROM fraud
GROUP BY gender;

-- =========================================================================
-- 5. DEMOGRAPHIC PROFILING: AVERAGE AGE AT TIME OF FRAUD
-- Calculating the exact age of suspects when the suspicious transactions occurred
-- =========================================================================
WITH fraud AS (
    SELECT t.account_id, c.client_id, c.gender, TIMESTAMPDIFF(YEAR, c.Birth_Date, t.date) AS age
    FROM trans t
    JOIN disp d ON t.account_id = d.account_id
    JOIN client c ON d.client_id = c.client_id
    WHERE d.type = 'OWNER'
    GROUP BY t.account_id, t.date, c.client_id, c.gender, c.Birth_Date
    HAVING count(t.trans_id) > 5
)
SELECT gender, COUNT(DISTINCT client_id) AS suspect_count, AVG(age) AS average_age_at_fraud
FROM fraud
GROUP BY gender;

-- =========================================================================
-- 6. GEOSPATIAL ANALYSIS: FRAUD HOTSPOTS
-- Identifying the districts with the highest concentration of fraud suspects
-- =========================================================================
WITH fraud AS (
    SELECT t.account_id, c.client_id, ds.A2
    FROM trans t
    JOIN disp d ON t.account_id = d.account_id
    JOIN client c ON d.client_id = c.client_id
    JOIN district ds ON c.district_id = ds.A1
    WHERE d.type = 'OWNER'
    GROUP BY t.account_id, t.date, c.client_id, ds.A2
    HAVING count(t.trans_id) > 5
)
SELECT A2 AS district_name, COUNT(DISTINCT client_id) AS number_of_suspects
FROM fraud
GROUP BY A2
ORDER BY number_of_suspects DESC;

-- =========================================================================
-- 7. BUST-OUT FRAUD INVESTIGATION (THE LOAN HEIST)
-- Cross-referencing fraud suspects with loan defaults (Status D: default/unpaid)
-- =========================================================================
WITH fraud AS (
    SELECT t.account_id, t.date, c.client_id, l.status, l.amount
    FROM trans t
    JOIN disp d ON t.account_id = d.account_id
    JOIN client c ON d.client_id = c.client_id
    JOIN loan l ON t.account_id = l.account_id
    WHERE d.type = 'OWNER'
      AND l.status IN ('A', 'D')
    GROUP BY t.account_id, t.date, c.client_id, l.status, l.amount
    HAVING count(t.trans_id) > 5
)
SELECT client_id, amount AS loan_amount, status AS loan_status
FROM fraud
GROUP BY client_id, loan_amount, loan_status
ORDER BY loan_amount DESC;