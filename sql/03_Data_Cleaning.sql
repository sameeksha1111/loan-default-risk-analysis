USE loan_default_risk;
SELECT
    emp_length,
    CASE
        WHEN emp_length IS NULL
          OR TRIM(emp_length) = ''
          OR UPPER(TRIM(emp_length)) IN ('N/A', 'NA')
        THEN 'Unknown'
        ELSE TRIM(emp_length)
    END AS clean_emp_length
FROM raw_loans_full;
SELECT loan_status,
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
        END AS clean_loan_status
FROM raw_loans_full;

SELECT purpose,
NULLIF(LOWER(TRIM(purpose)),'') AS clean_purpose
FROM raw_loans_full;

SELECT home_ownership,
NULLIF(UPPER(TRIM(home_ownership)),'') AS clean_home_ownership
FROM raw_loans_full;

SELECT
    verification_status,
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
    END AS clean_verification_status

FROM raw_loans_full;

SELECT addr_state,NULLIF(UPPER(TRIM(addr_state)), '') AS clean_addr_state FROM raw_loans_full;
-- numeric data conversion
SELECT
    loan_amnt,
    CASE
        WHEN TRIM(loan_amnt) REGEXP
             '^[0-9]+([.][0-9]+)?$'
         AND CAST(TRIM(loan_amnt) AS DECIMAL(15,2)) > 0
        THEN CAST(TRIM(loan_amnt) AS DECIMAL(15,2))
        ELSE NULL
    END AS clean_loan_amnt
FROM raw_loans_full;
SELECT
    annual_inc,
    CASE
        WHEN TRIM(annual_inc) REGEXP
             '^[0-9]+([.][0-9]+)?$'
        THEN CAST(TRIM(annual_inc) AS DECIMAL(15,2))
        ELSE NULL
    END AS clean_annual_inc
FROM raw_loans_full;
SELECT
    dti,
    CASE
        WHEN TRIM(dti) REGEXP
             '^[0-9]+([.][0-9]+)?$'
        THEN CAST(TRIM(dti) AS DECIMAL(10,2))
        ELSE NULL
    END AS clean_dti
FROM raw_loans_full;

SELECT
    delinq_2yrs,
    CASE
        WHEN TRIM(delinq_2yrs) REGEXP '^[0-9]+$'
        THEN CAST(TRIM(delinq_2yrs) AS UNSIGNED)
        ELSE NULL
    END AS clean_delinq_2yrs
FROM raw_loans_full;
SELECT
    inq_last_6mths,
    CASE
        WHEN TRIM(inq_last_6mths) REGEXP '^[0-9]+$'
        THEN CAST(TRIM(inq_last_6mths) AS UNSIGNED)
        ELSE NULL
    END AS clean_inq_last_6mths
FROM raw_loans_full;
SELECT
    open_acc,
    CASE
        WHEN TRIM(open_acc) REGEXP '^[0-9]+$'
        THEN CAST(TRIM(open_acc) AS UNSIGNED)
        ELSE NULL
    END AS clean_open_acc
FROM raw_loans_full;
SELECT
    pub_rec,
    CASE
        WHEN TRIM(pub_rec) REGEXP '^[0-9]+$'
        THEN CAST(TRIM(pub_rec) AS UNSIGNED)
        ELSE NULL
    END AS clean_pub_rec
FROM raw_loans_full;
-- percentage cleaning
SELECT
    int_rate,
    CASE
        WHEN TRIM(int_rate) REGEXP
             '^[0-9]+([.][0-9]+)?%$'
        THEN CAST(
            REPLACE(TRIM(int_rate), '%', '')
            AS DECIMAL(7,2)
        )
        ELSE NULL
    END AS clean_int_rate
FROM raw_loans_full;

SELECT
    revol_util,
    CASE
        WHEN TRIM(revol_util) REGEXP
             '^[0-9]+([.][0-9]+)?%$'
        THEN CAST(
            REPLACE(TRIM(revol_util), '%', '')
            AS DECIMAL(7,2)
        )
        ELSE NULL
    END AS clean_revol_util
FROM raw_loans_full;
-- Date formattting
SELECT
    issue_d,

    CASE
        WHEN TRIM(issue_d) REGEXP
             '^[A-Za-z]{3}-[0-9]{2}$'
        THEN STR_TO_DATE(
            CONCAT('01-', TRIM(issue_d)),
            '%d-%b-%y'
        )

        ELSE NULL
    END AS clean_issue_d

FROM raw_loans_full;
SELECT
    term,

    CASE
        WHEN LOWER(TRIM(term)) REGEXP
             '^[0-9]+[[:space:]]+months$'

        THEN CAST(
            SUBSTRING_INDEX(TRIM(term), ' ', 1)
            AS UNSIGNED
        )

        ELSE NULL
    END AS clean_term

FROM raw_loans_full;
SELECT
    issue_d,
    COUNT(*) AS total_loans
FROM raw_loans_full
GROUP BY issue_d
ORDER BY issue_d;