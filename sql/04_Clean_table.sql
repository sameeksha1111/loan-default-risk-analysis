USE loan_default_risk;
SHOW TABLES ;

CREATE TABLE clean_loans AS

SELECT

    -- 1. Loan identifier
    NULLIF(TRIM(id), '') AS id,


    -- 2. Loan amount
    CASE
        WHEN TRIM(loan_amnt) REGEXP
             '^[0-9]+([.][0-9]+)?$'
         AND CAST(TRIM(loan_amnt) AS DECIMAL(15,2)) > 0

        THEN CAST(
            TRIM(loan_amnt) AS DECIMAL(15,2)
        )

        ELSE NULL
    END AS loan_amnt,


    -- 3. Annual income
    CASE
        WHEN TRIM(annual_inc) REGEXP
             '^[0-9]+([.][0-9]+)?$'

        THEN CAST(
            TRIM(annual_inc) AS DECIMAL(15,2)
        )

        ELSE NULL
    END AS annual_inc,


    -- 4. Employment length
    CASE
        WHEN emp_length IS NULL
             OR TRIM(emp_length) = ''
             OR UPPER(TRIM(emp_length)) IN ('N/A', 'NA')

        THEN 'Unknown'

        ELSE TRIM(emp_length)
    END AS emp_length,


    -- 5. Loan purpose
    NULLIF(
        LOWER(TRIM(purpose)), ''
    ) AS purpose,


    -- 6. Borrower state
    NULLIF(
        UPPER(TRIM(addr_state)), ''
    ) AS addr_state,


    -- 7. Loan status
    CASE
        WHEN loan_status IS NULL
             OR TRIM(loan_status) = ''
             OR UPPER(TRIM(loan_status)) IN ('N/A', 'NA')

        THEN 'Unknown'

        WHEN UPPER(TRIM(loan_status)) = 'FULLY PAID'
        THEN 'Fully Paid'

        WHEN UPPER(TRIM(loan_status)) = 'CHARGED OFF'
        THEN 'Charged Off'

        WHEN UPPER(TRIM(loan_status)) = 'CURRENT'
        THEN 'Current'

        ELSE TRIM(loan_status)
    END AS loan_status,


    -- 8. Loan issue date
    CASE
        WHEN UPPER(TRIM(issue_d)) REGEXP
          '^(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-[0-9]{2}$'

        THEN STR_TO_DATE(
            CONCAT('01-', TRIM(issue_d)),
            '%d-%b-%y'
        )

        ELSE NULL
    END AS issue_d,


    -- 9. Debt-to-income ratio
    CASE
        WHEN TRIM(dti) REGEXP
             '^[0-9]+([.][0-9]+)?$'

        THEN CAST(
            TRIM(dti) AS DECIMAL(10,2)
        )

        ELSE NULL
    END AS dti,


    -- 10. Delinquencies in last 2 years
    CASE
        WHEN TRIM(delinq_2yrs) REGEXP '^[0-9]+$'

        THEN CAST(
            TRIM(delinq_2yrs) AS UNSIGNED
        )

        ELSE NULL
    END AS delinq_2yrs,


    -- 11. Revolving credit utilization
    CASE
        WHEN TRIM(revol_util) REGEXP
             '^[0-9]+([.][0-9]+)?%$'

        THEN CAST(
            REPLACE(TRIM(revol_util), '%', '')
            AS DECIMAL(7,2)
        )

        ELSE NULL
    END AS revol_util,


    -- 12. Credit inquiries in last 6 months
    CASE
        WHEN TRIM(inq_last_6mths) REGEXP '^[0-9]+$'

        THEN CAST(
            TRIM(inq_last_6mths) AS UNSIGNED
        )

        ELSE NULL
    END AS inq_last_6mths,


    -- 13. Open credit accounts
    CASE
        WHEN TRIM(open_acc) REGEXP '^[0-9]+$'

        THEN CAST(
            TRIM(open_acc) AS UNSIGNED
        )

        ELSE NULL
    END AS open_acc,


    -- 14. Public records
    CASE
        WHEN TRIM(pub_rec) REGEXP '^[0-9]+$'

        THEN CAST(
            TRIM(pub_rec) AS UNSIGNED
        )

        ELSE NULL
    END AS pub_rec,


    -- 15. Loan term in months
    CASE
        WHEN LOWER(TRIM(term)) REGEXP
             '^[0-9]+[ ]+months$'

        THEN CAST(
            SUBSTRING_INDEX(TRIM(term), ' ', 1)
            AS UNSIGNED
        )

        ELSE NULL
    END AS term,


    -- 16. Interest rate
    CASE
        WHEN TRIM(int_rate) REGEXP
             '^[0-9]+([.][0-9]+)?%$'

        THEN CAST(
            REPLACE(TRIM(int_rate), '%', '')
            AS DECIMAL(7,2)
        )

        ELSE NULL
    END AS int_rate,


    -- 17. Home ownership
    NULLIF(
        UPPER(TRIM(home_ownership)), ''
    ) AS home_ownership,


    -- 18. Verification status
    CASE
        WHEN verification_status IS NULL
             OR TRIM(verification_status) = ''

        THEN NULL

        WHEN UPPER(TRIM(verification_status)) = 'VERIFIED'
        THEN 'Verified'

        WHEN UPPER(TRIM(verification_status)) = 'SOURCE VERIFIED'
        THEN 'Source Verified'

        WHEN UPPER(TRIM(verification_status)) = 'NOT VERIFIED'
        THEN 'Not Verified'

        ELSE TRIM(verification_status)
    END AS verification_status

FROM raw_loans_full;
-- validate table was created
SHOW TABLES LIKE 'clean_loans';

SELECT
    'Raw Table' AS table_name,
    COUNT(*) AS total_rows
FROM raw_loans_full

UNION ALL

SELECT
    'Clean Table' AS table_name,
    COUNT(*) AS total_rows
FROM clean_loans;

DESCRIBE clean_loans;

-- checking duplicate loan ids 
SELECT
    id,
    COUNT(*) AS total_records
FROM clean_loans
GROUP BY id
HAVING COUNT(*) > 1;
-- checking missing clean values
SELECT
    COUNT(*) AS total_loans,

    SUM(id IS NULL) AS missing_ids,

    SUM(loan_amnt IS NULL) AS null_loan_amounts,

    SUM(annual_inc IS NULL) AS null_annual_incomes,

    SUM(dti IS NULL) AS null_dti,

    SUM(issue_d IS NULL) AS null_issue_dates,

    SUM(term IS NULL) AS null_terms,

    SUM(int_rate IS NULL) AS null_interest_rates,

    SUM(revol_util IS NULL) AS null_revol_util,

    SUM(delinq_2yrs IS NULL) AS null_delinquencies,

    SUM(inq_last_6mths IS NULL) AS null_inquiries,

    SUM(open_acc IS NULL) AS null_open_accounts,

    SUM(pub_rec IS NULL) AS null_public_records

FROM clean_loans;
-- verify loan status categories
SELECT
    loan_status,
    COUNT(*) AS total_loans
FROM clean_loans
GROUP BY loan_status
ORDER BY total_loans DESC;

SELECT
    r.annual_inc AS original_income,
    COUNT(*) AS total_loans
FROM raw_loans_full r
JOIN clean_loans c
    ON TRIM(r.id) = c.id
WHERE c.annual_inc IS NULL
GROUP BY r.annual_inc
ORDER BY total_loans DESC
LIMIT 20;

SELECT
    COUNT(*) AS total_loans,

    SUM(
        annual_inc IS NULL
        OR TRIM(annual_inc) = ''
    ) AS originally_missing,

    SUM(
        annual_inc IS NOT NULL
        AND TRIM(annual_inc) <> ''
        AND TRIM(annual_inc) NOT REGEXP
            '^[0-9]+([.][0-9]+)?$'
    ) AS invalid_numeric_format

FROM raw_loans_full;

-- found an error for annual income
SELECT
    CAST(
        CAST('1e+05' AS DOUBLE)
        AS DECIMAL(15,2)
    ) AS corrected_income;
-- update the clean table
UPDATE clean_loans AS c
JOIN raw_loans_full AS r
    ON c.id = TRIM(r.id)

SET c.annual_inc =
    CAST(
        CAST(TRIM(r.annual_inc) AS DOUBLE)
        AS DECIMAL(15,2)
    )

WHERE c.annual_inc IS NULL
  AND TRIM(r.annual_inc) REGEXP
      '^[0-9]+([.][0-9]+)?[eE][+-]?[0-9]+$'
  AND CAST(TRIM(r.annual_inc) AS DOUBLE)
      BETWEEN 0 AND 9999999999999.99;
      
SET SQL_SAFE_UPDATES = 0;
UPDATE clean_loans AS c
JOIN raw_loans_full AS r
    ON c.id = TRIM(r.id)

SET c.annual_inc =
    CAST(
        CAST(TRIM(r.annual_inc) AS DOUBLE)
        AS DECIMAL(15,2)
    )

WHERE c.annual_inc IS NULL
  AND TRIM(r.annual_inc) REGEXP
      '^[0-9]+([.][0-9]+)?[eE][+-]?[0-9]+$'
  AND CAST(TRIM(r.annual_inc) AS DOUBLE)
      BETWEEN 0 AND 9999999999999.99;

SELECT
    COUNT(*) AS total_loans,
    SUM(annual_inc IS NULL) AS null_annual_income
FROM clean_loans;