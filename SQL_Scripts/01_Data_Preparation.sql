-- =========================================================================
-- DATABASE SETUP & DATA PREPARATION PIPELINE
-- Goal: Import raw data, fix formatting issues, and standardize values.
-- =========================================================================

USE paymoret; -- Ensure the correct database is selected

-- Disable safe updates to allow bulk updates without a WHERE clause
SET SQL_SAFE_UPDATES = 0;

-- =========================================================================
-- STEP 1: DATA IMPORT & FIXING CARRIAGE RETURN (\r\n) BLEEDING
-- =========================================================================
TRUNCATE TABLE trans;

LOAD DATA LOCAL INFILE 'Path_To_Your_File/trans.csv' 
INTO TABLE trans
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- =========================================================================
-- STEP 2: DATE FORMAT STANDARDIZATION (String to SQL DATE)
-- =========================================================================
-- Clean 'trans' table dates (Format: YYMMDD)
UPDATE trans
SET date = STR_TO_DATE(date, '%y%m%d');

ALTER TABLE trans
MODIFY COLUMN date DATE;

-- Clean 'client' table birth dates (Format: MM/DD/YYYY)
UPDATE client
SET Birth_Date = STR_TO_DATE(Birth_date, '%m/%d/%Y');

ALTER TABLE client 
MODIFY COLUMN Birth_Date DATE;

-- =========================================================================
-- STEP 3: DATA TRANSLATION & STANDARDIZATION (Czech to English)
-- =========================================================================
-- Translate transaction types
UPDATE trans
SET type =
CASE
    WHEN type = 'PRIJEM' THEN 'Credit'
    WHEN type = 'VYDAJ' THEN 'Debit'
    WHEN type = 'VYBER' THEN 'Withdrawal'
    ELSE type
END;

-- Translate transaction operations
UPDATE trans
SET operation =
CASE
    WHEN operation = 'VKLAD' THEN 'Cash Deposit'
    WHEN operation = 'PREVOD Z UCTU' THEN 'Incoming Transfer'
    WHEN operation = 'VYBER' THEN 'Cash Withdrawal'
    WHEN operation = 'PREVOD NA UCET' THEN 'Outgoing Transfer'
    WHEN operation = 'VYBER KARTOU' THEN 'Credit Card Withdrawal'
    ELSE operation
END;

-- Re-enable safe updates to protect the database
SET SQL_SAFE_UPDATES = 1;