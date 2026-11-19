# Loan Default Risk Analysis | SQL & Power BI

**An end-to-end data analytics project using MySQL and Power BI to analyze historical loan performance, identify borrower segments with higher charge-off rates, and support credit risk investigations.**

## 1. Project Overview

This project analyzes **39,717 historical LendingClub loans issued between 2007 and 2011**.

I used **MySQL** to inspect, clean, and prepare the loan data, followed by **Power BI** to build an interactive three-page dashboard.

The dashboard helps understand overall loan performance, compare historical charge-off rates across borrower groups, and identify financial conditions that may require further investigation.

## 2. Tech Stack

- **MySQL:** Data quality checks, cleaning, standardization, and preparation.
- **SQL:** Data validation, filtering, and analysis.
- **Power BI:** Interactive dashboards and data visualization.
- **Power Query:** Data loading and transformation.
- **DAX:** Calculated measures, KPIs, income and DTI categories, and investigation flags.

## 3. Data Source

**Dataset:** Lending Club Loan Dataset (2007–2011)

**Source:** Historical loan records from LendingClub, available through Kaggle.

**Dataset link:** https://www.kaggle.com/datasets/imsparsh/lending-club-loan-dataset-2007-2011

**File:** `loan.csv`

The dataset contains information about loan amounts, repayment status, annual income, employment length, loan purpose, debt-to-income ratio, revolving credit utilization, and credit history.

**Records analyzed:** 39,717

## 4. Features & Highlights

### Business Problem

A lending company needs to understand **which customer segments have the highest loan default risk** and **which loan applications may require manual review** by the credit team.

The challenge is to identify patterns across borrower income, employment history, loan purpose, and financial indicators that may be associated with higher default risk.

### Project Goal

Build an interactive **SQL and Power BI dashboard** to analyze historical loan performance, identify **borrower segments with higher charge-off rates**, and highlight **financial conditions that may help the credit team prioritize further investigation**.

### 5.Key Dashboard Visuals

**Page 1 — Portfolio Overview**

Provides an overall picture of the loan portfolio.

- **KPI Cards:** Total Loans, Total Loan Amount, Resolved Loans, Charged-Off Loans, and Historical Charge-Off Rate.
- **Monthly Loan Issuance Trend:** Shows how the number of issued loans changed over time.
- **Loan Status Distribution:** Compares Fully Paid, Charged Off, and Current loans.
- **Loan Distribution by Repayment Term:** Compares the number of 36-month and 60-month loans.
- **Issue Year Slicer:** Allows users to explore loan performance by year.

**Page 2 — Borrower Risk Analysis**

Compares historical loan outcomes across different borrower groups.

- **Income Bracket Analysis:** Compares charge-off rates across income groups, with a detailed matrix showing repayment-term differences.
- **Loan Purpose Analysis:** Compares loan volume and historical charge-off rates by borrowing purpose.
- **DTI Band Analysis:** Shows how charge-off rates vary across debt-to-income ranges.
- **Employment Length Analysis:** Compares historical charge-off rates across employment-length categories.

**Page 3 — Credit Review**

Uses four illustrative investigation conditions based on DTI, revolving utilization, past delinquencies, and recent credit inquiries.

- **KPI Cards:** Total Historical Loans, Records With Flags, and Multi-Flag Records.
- **Historical Loans by Indicator Count:** Shows how many loans meet 0, 1, 2, or 3 conditions, with tooltips showing the individual flag counts.
- **Historical Loan Outcomes by Indicator Count:** Compares Fully Paid and Charged Off proportions across indicator-count groups.
- **Historical Charge-Off Rate by Individual Flag:** Shows the historical charge-off rate for loans meeting each financial condition.

These investigation conditions are used to explore historical patterns, not to predict individual defaults or make automatic lending decisions.

### 6. Business Insights & Impact

The analysis covered **39,717 loans**, including **38,577 resolved loans** and **5,627 charged-off loans**, resulting in a **14.6% historical charge-off rate**.

Loan issuance increased substantially between 2009 and 2011. The borrower analysis also showed differences in historical charge-off rates across income groups, debt-to-income ranges, loan purposes, and employment lengths.

On the Credit Review page, **13,907 loans met at least one investigation condition**, while **1,555 met multiple conditions**. The historical charge-off rate increased from **12.45% for loans with no flags** to **22.21% for loans with two flags**.

Among individual conditions, the **Inquiry flag (20.4%)** and **Utilization flag (20.1%)** showed the highest historical charge-off rates.

**Business Value:** The dashboard gives the credit team a single place to monitor portfolio performance, compare borrower segments, and identify patterns worth investigating. These findings can support further credit risk analysis and data-quality improvements, but should be validated before being used in lending decisions.

## 7. Screenshots
https://github.com/sameeksha1111/loan-default-risk-analysis/blob/main/screenshots/overview.png 
https://github.com/sameeksha1111/loan-default-risk-analysis/blob/main/screenshots/risk_analysis.png
