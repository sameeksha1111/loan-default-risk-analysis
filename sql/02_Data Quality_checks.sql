USE loan_default_risk;
-- Duplicate id
SELECT id , COUNT(*) AS Total_occurences
FROM raw_loans_full
GROUP BY id
HAVING COUNT(*) > 1;
-- missing , whitespce ids
SELECT COUNT(*) AS missing_id
FROM raw_loans_full
WHERE id IS NULL;
SELECT COUNT(*) AS blank_id
FROM raw_loans_full
WHERE TRIM(id) =''; 
-- Missing values in other imp columns
SELECT COUNT(*) AS missing_inc
FROM raw_loans_full
WHERE annual_inc IS NULL OR TRIM(annual_inc)='';
SELECT COUNT(*) AS missing_length
FROM raw_loans_full
WHERE emp_length IS NULL OR TRIM(emp_length)='';
SELECT COUNT(*) AS missing_purpose
FROM raw_loans_full
WHERE purpose IS NULL OR TRIM(purpose)='';
SELECT COUNT(*) AS missing_addr
FROM raw_loans_full
WHERE addr_state IS NULL OR TRIM(addr_state)='';
SELECT COUNT(*) AS missing_status
FROM raw_loans_full
WHERE loan_status IS NULL OR TRIM(loan_status)='';
-- Text consistency checks
SELECT DISTINCT Loan_status
from raw_loans_full;
SELECT loan_status,COUNT(*) AS total_status
FROM raw_loans_full
GROUP BY loan_status;
SELECT *
FROM raw_loans_full
WHERE CHAR_LENGTH(loan_status)  <> CHAR_LENGTH(TRIM(loan_status) ); 
SELECT DISTINCT purpose
from raw_loans_full;
SELECT purpose ,COUNT(*) AS total_purpose
FROM raw_loans_full
GROUP BY purpose;
SELECT *
FROM raw_loans_full
WHERE CHAR_LENGTH(purpose)  <> CHAR_LENGTH(TRIM(purpose) ); 
SELECT DISTINCT emp_length
FROM raw_loans_full;
SELECT emp_length, COUNT(*) AS total_count
FROM raw_loans_full
GROUP BY emp_length;
SELECT COUNT(*) AS extra_spaces
FROM raw_loans_full
WHERE CHAR_LENGTH(emp_length)
   <> CHAR_LENGTH(TRIM(emp_length));
SELECT DISTINCT home_ownership
FROM raw_loans_full;
SELECT home_ownership, COUNT(*) AS total_count
FROM raw_loans_full
GROUP BY home_ownership;
SELECT COUNT(*) AS extra_spaces
FROM raw_loans_full
WHERE CHAR_LENGTH(home_ownership)
   <> CHAR_LENGTH(TRIM(home_ownership));
SELECT DISTINCT verification_status
FROM raw_loans_full;
SELECT verification_status, COUNT(*) AS total_count
FROM raw_loans_full
GROUP BY verification_status;
SELECT COUNT(*) AS extra_spaces
FROM raw_loans_full
WHERE CHAR_LENGTH(verification_status)
   <> CHAR_LENGTH(TRIM(verification_status));
SELECT DISTINCT addr_state
FROM raw_loans_full;
SELECT addr_state, COUNT(*) AS total_count
FROM raw_loans_full
GROUP BY addr_state;
SELECT COUNT(*) AS extra_spaces
FROM raw_loans_full
WHERE CHAR_LENGTH(addr_state)
   <> CHAR_LENGTH(TRIM(addr_state));
-- Numeric validation
SELECT COUNT(*) AS invalid_numeric
FROM raw_loans_full
WHERE loan_amnt IS NOT NULL
  AND TRIM(loan_amnt) <> ''
  AND TRIM(loan_amnt) NOT REGEXP
      '^-?[0-9]+([.][0-9]+)?$';
SELECT COUNT(*) AS zero_or_negative
FROM raw_loans_full
WHERE TRIM(loan_amnt) REGEXP
      '^-?[0-9]+([.][0-9]+)?$'
  AND CAST(TRIM(loan_amnt) AS DECIMAL(15,2)) <= 0;
SELECT
    MIN(CAST(loan_amnt AS DECIMAL(15,2))) AS min_loan,
    MAX(CAST(loan_amnt AS DECIMAL(15,2))) AS max_loan
FROM raw_loans_full
WHERE TRIM(loan_amnt) REGEXP
      '^-?[0-9]+([.][0-9]+)?$';
SELECT COUNT(*) AS invalid_income
FROM raw_loans_full
WHERE annual_inc IS NOT NULL
  AND TRIM(annual_inc) <> ''
  AND TRIM(annual_inc) NOT REGEXP
      '^-?[0-9]+([.][0-9]+)?$';
SELECT COUNT(*) AS zero_or_negative
FROM raw_loans_full
WHERE TRIM(annual_inc) REGEXP
      '^-?[0-9]+([.][0-9]+)?$'
  AND CAST(TRIM(annual_inc) AS DECIMAL(15,2)) <= 0;
SELECT
    MIN(CAST(annual_inc AS DECIMAL(15,2))) AS min_inc,
    MAX(CAST(annual_inc AS DECIMAL(15,2))) AS max_inc
FROM raw_loans_full
WHERE TRIM(annual_inc) REGEXP
      '^-?[0-9]+([.][0-9]+)?$';
SELECT *
FROM raw_loans_full
WHERE dti IS NULL OR TRIM(dti) = '';
SELECT COUNT(*) AS invalid_dti
FROM raw_loans_full
WHERE dti IS NOT NULL
  AND TRIM(dti) <> ''
  AND TRIM(dti) NOT REGEXP
      '^-?[0-9]+([.][0-9]+)?$';
SELECT COUNT(*) AS zero_or_negative
FROM raw_loans_full
WHERE TRIM(dti) REGEXP
      '^-?[0-9]+([.][0-9]+)?$'
  AND CAST(TRIM(dti) AS DECIMAL(15,2)) <= 0;
SELECT
    MIN(CAST(dti AS DECIMAL(15,2))) AS min_dti,
    MAX(CAST(dti AS DECIMAL(15,2))) AS max_dti
FROM raw_loans_full
WHERE TRIM(dti) REGEXP
      '^-?[0-9]+([.][0-9]+)?$';
WITH validated AS (
    SELECT
        TRIM(delinq_2yrs) AS raw_value,
        CASE
            WHEN TRIM(delinq_2yrs) REGEXP '^-?[0-9]+$'
            THEN CAST(TRIM(delinq_2yrs) AS SIGNED)
            ELSE NULL
        END AS num_value
    FROM raw_loans_full
)
SELECT
    SUM(raw_value IS NULL OR raw_value = '') AS missing_count,
    SUM(UPPER(raw_value) IN ('N/A', 'NA', 'NULL')) AS placeholder_count,
    SUM(raw_value IS NOT NULL
        AND raw_value <> ''
        AND UPPER(raw_value) NOT IN ('N/A', 'NA', 'NULL')
        AND raw_value NOT REGEXP '^-?[0-9]+$') AS invalid_count,
    SUM(num_value < 0) AS negative_count,
    SUM(num_value = 0) AS zero_count,
    MIN(num_value) AS min_value,
    MAX(num_value) AS max_value
FROM validated;
WITH validated AS (
    SELECT
        TRIM(inq_last_6mths) AS raw_value,
        CASE
            WHEN TRIM(inq_last_6mths) REGEXP '^-?[0-9]+$'
            THEN CAST(TRIM(inq_last_6mths) AS SIGNED)
            ELSE NULL
        END AS num_value
    FROM raw_loans_full
)
SELECT
    SUM(raw_value IS NULL OR raw_value = '') AS missing_count,
    SUM(UPPER(raw_value) IN ('N/A', 'NA', 'NULL')) AS placeholder_count,
    SUM(raw_value IS NOT NULL
        AND raw_value <> ''
        AND UPPER(raw_value) NOT IN ('N/A', 'NA', 'NULL')
        AND raw_value NOT REGEXP '^-?[0-9]+$') AS invalid_count,
    SUM(num_value < 0) AS negative_count,
    SUM(num_value = 0) AS zero_count,
    MIN(num_value) AS min_value,
    MAX(num_value) AS max_value
FROM validated;
WITH validated AS (
    SELECT
        TRIM(open_acc) AS raw_value,
        CASE
            WHEN TRIM(open_acc) REGEXP '^-?[0-9]+$'
            THEN CAST(TRIM(open_acc) AS SIGNED)
            ELSE NULL
        END AS num_value
    FROM raw_loans_full
)
SELECT
    SUM(raw_value IS NULL OR raw_value = '') AS missing_count,
    SUM(UPPER(raw_value) IN ('N/A', 'NA', 'NULL')) AS placeholder_count,
    SUM(raw_value IS NOT NULL
        AND raw_value <> ''
        AND UPPER(raw_value) NOT IN ('N/A', 'NA', 'NULL')
        AND raw_value NOT REGEXP '^-?[0-9]+$') AS invalid_count,
    SUM(num_value < 0) AS negative_count,
    SUM(num_value = 0) AS zero_count,
    MIN(num_value) AS min_value,
    MAX(num_value) AS max_value
FROM validated;
WITH validated AS (
    SELECT
        TRIM(pub_rec) AS raw_value,
        CASE
            WHEN TRIM(pub_rec) REGEXP '^-?[0-9]+$'
            THEN CAST(TRIM(pub_rec) AS SIGNED)
            ELSE NULL
        END AS num_value
    FROM raw_loans_full
)
SELECT
    SUM(raw_value IS NULL OR raw_value = '') AS missing_count,
    SUM(UPPER(raw_value) IN ('N/A', 'NA', 'NULL')) AS placeholder_count,
    SUM(raw_value IS NOT NULL
        AND raw_value <> ''
        AND UPPER(raw_value) NOT IN ('N/A', 'NA', 'NULL')
        AND raw_value NOT REGEXP '^-?[0-9]+$') AS invalid_count,
    SUM(num_value < 0) AS negative_count,
    SUM(num_value = 0) AS zero_count,
    MIN(num_value) AS min_value,
    MAX(num_value) AS max_value
FROM validated;
WITH validated AS (
    SELECT
        TRIM(int_rate) AS raw_value,
        CASE
            WHEN TRIM(int_rate) REGEXP
                 '^-?[0-9]+([.][0-9]+)?%?$'
            THEN CAST(
                REPLACE(TRIM(int_rate), '%', '')
                AS DECIMAL(12,4)
            )
            ELSE NULL
        END AS num_value
    FROM raw_loans_full
)
SELECT
    SUM(raw_value IS NULL OR raw_value = '') AS missing_count,
    SUM(raw_value IS NOT NULL
        AND raw_value <> ''
        AND raw_value NOT REGEXP
            '^-?[0-9]+([.][0-9]+)?%?$') AS invalid_count,
    SUM(num_value < 0) AS negative_count,
    SUM(num_value = 0) AS zero_count,
    SUM(num_value > 100) AS above_100_count,
    MIN(num_value) AS min_value,
    MAX(num_value) AS max_value
FROM validated;
WITH validated AS (
    SELECT
        TRIM(revol_util) AS raw_value,
        CASE
            WHEN TRIM(revol_util) REGEXP
                 '^-?[0-9]+([.][0-9]+)?%?$'
            THEN CAST(
                REPLACE(TRIM(revol_util), '%', '')
                AS DECIMAL(12,4)
            )
            ELSE NULL
        END AS num_value
    FROM raw_loans_full
)
SELECT
    SUM(raw_value IS NULL OR raw_value = '') AS missing_count,
    SUM(raw_value IS NOT NULL
        AND raw_value <> ''
        AND raw_value NOT REGEXP
            '^-?[0-9]+([.][0-9]+)?%?$') AS invalid_count,
    SUM(num_value < 0) AS negative_count,
    SUM(num_value = 0) AS zero_count,
    SUM(num_value > 100) AS above_100_count,
    MIN(num_value) AS min_value,
    MAX(num_value) AS max_value
FROM validated;
-- missing issue date
SELECT COUNT(*) AS missing_dates
FROM raw_loans_full
WHERE issue_d IS NULL
   OR TRIM(issue_d) = '';
 -- invalid date formats  
   SELECT COUNT(*) AS invalid_date_format
FROM raw_loans_full
WHERE issue_d IS NOT NULL
  AND TRIM(issue_d) <> ''
  AND TRIM(issue_d) NOT REGEXP
      '^[A-Za-z]{3}-[0-9]{2}$';