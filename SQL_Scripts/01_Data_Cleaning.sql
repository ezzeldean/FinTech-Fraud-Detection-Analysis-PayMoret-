-- =========================================================================
-- STEP 1: DATE FORMAT STANDARDIZATION
-- Converting string dates to standard SQL DATE format (YYYY-MM-DD)
-- =========================================================================

-- Clean 'trans' table dates
UPDATE trans
SET date = STR_TO_DATE(date, '%y%m%d');

ALTER TABLE trans
MODIFY COLUMN date DATE;

-- Clean 'client' table birth dates
UPDATE client
SET Birth_Date = STR_TO_DATE(Birth_date, '%m/%d/%Y');

ALTER TABLE client 
MODIFY COLUMN Birth_Date DATE;

-- =========================================================================
-- STEP 2: DATA TRANSLATION & STANDARDIZATION (CZECH TO ENGLISH)
-- Translating transaction types and operations for reporting
-- =========================================================================

UPDATE trans
SET type =
CASE
    WHEN type = 'PRIJEM' THEN 'Credit'
    WHEN type = 'VYDAJ' THEN 'Debit'
    WHEN type = 'VYBER' THEN 'Withdrawal'
    ELSE type
END;

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