
CREATE DATABASE FinanceDB;
USE FinanceDB;

CREATE TABLE financial_loan (
    id INT,
    member_id BIGINT,
    
    loan_amount DECIMAL(12,2),
    funded_amount DECIMAL(12,2),
    funded_amount_inv DECIMAL(12,2),
    
    term VARCHAR(50),
    int_rate DECIMAL(5,2),
    installment DECIMAL(10,2),
    
    grade VARCHAR(5),
    sub_grade VARCHAR(10),
    
    emp_title VARCHAR(255),
    emp_length VARCHAR(50),
    
    home_ownership VARCHAR(50),
    annual_income DECIMAL(15,2),
    
    verification_status VARCHAR(50),
    
    issue_date VARCHAR(20),
    loan_status VARCHAR(50),
    
    purpose VARCHAR(100),
    address_state VARCHAR(10),
    
    dti DECIMAL(10,2),
    
    delinq_2yrs INT,
    earliest_credit_line VARCHAR(20),
    
    inquiries_last_6mths INT,
    open_acc INT,
    pub_rec INT,
    
    revolving_balance DECIMAL(15,2),
    revolving_utilization DECIMAL(10,2),
    
    total_acc INT,
    
    total_payment DECIMAL(15,2),
    total_payment_inv DECIMAL(15,2),
    
    total_received_principal DECIMAL(15,2),
    total_received_interest DECIMAL(15,2),
    
    total_received_late_fee DECIMAL(15,2),
    
    recoveries DECIMAL(15,2),
    collection_recovery_fee DECIMAL(15,2),
    
    last_payment_date VARCHAR(20),
    last_payment_amount DECIMAL(15,2),
    
    next_payment_date VARCHAR(20),
    last_credit_pull_date VARCHAR(20),
    
    collections_12_mths_ex_med INT,
    months_since_last_delinq INT,
    months_since_last_record INT,
    
    application_type VARCHAR(50)
);

select * from financial_loan limit 19;

-- Count Total Loans *This shows how many loan records are in the dataset.
SELECT COUNT(*) AS total_loans
FROM financial_loan;

-- Total Loan Amount Issued *This shows the total value of loans given out.
SELECT 
    SUM(loan_amount) AS total_disbursed
FROM financial_loan;

-- Total Amount Collected *This shows how much money has been repaid.
select
   sum(total_payment) as total_collected
   from financial_loan;

-- Overall Portfolio Summary *This gives your main dashboard KPI cards.
SELECT 
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(total_payment) AS total_collected,
    AVG(loan_amount) AS average_loan_amount,
    AVG(int_rate) AS average_interest_rate,
    AVG(dti) AS average_dti
FROM financial_loan;

-- Loan Status Breakdown *This shows how many loans are Fully Paid, Current, or Charged Off.
SELECT 
    loan_status,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(total_payment) AS total_collected
FROM financial_loan
GROUP BY loan_status
ORDER BY total_loans DESC;

-- Default Rate * This shows the percentage of loans that defaulted.
SELECT 
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate_percentage
FROM financial_loan;

-- Good Loan vs Bad Loan * This simplifies loan status into risk categories.
SELECT 
    CASE 
        WHEN loan_status = 'Fully Paid' THEN 'Good Loan'
        WHEN loan_status = 'Current' THEN 'Good Loan'
        WHEN loan_status = 'Charged Off' THEN 'Bad Loan'
        ELSE 'Other'
    END AS loan_category,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_amount
FROM financial_loan
GROUP BY loan_category;

-- Bad Loan Amount * This shows total exposure from defaulted loans.
SELECT 
    COUNT(*) AS bad_loan_count,
    SUM(loan_amount) AS bad_loan_amount
FROM financial_loan
WHERE loan_status = 'Charged Off';

-- Good Loan Amount *This shows the healthy part of the portfolio.
SELECT 
    COUNT(*) AS good_loan_count,
    SUM(loan_amount) AS good_loan_amount
FROM financial_loan
WHERE loan_status IN ('Fully Paid', 'Current');

-- Loan Risk by Grade * This shows which loan grades are most risky.
SELECT 
    grade,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS bad_loans,
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate_percentage,
    AVG(int_rate) AS average_interest_rate
FROM financial_loan
GROUP BY grade
ORDER BY default_rate_percentage DESC;

-- Loan Risk by Sub Grade* This gives deeper risk detail than grade.
SELECT 
    sub_grade,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS bad_loans,
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate_percentage
FROM financial_loan
GROUP BY sub_grade
ORDER BY default_rate_percentage DESC;

-- Loan Risk by State *This shows which states/regions carry the highest risk.
SELECT 
    address_state,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS bad_loans,
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate_percentage
FROM financial_loan
GROUP BY address_state
ORDER BY default_rate_percentage DESC;

-- Loan Risk by Purpose * This shows which loan purposes are riskier.
SELECT 
    purpose,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS bad_loans,
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate_percentage
FROM financial_loan
GROUP BY purpose
ORDER BY default_rate_percentage DESC;

-- Loan Risk by Home Ownership * This helps compare renters, mortgage holders, and owners.
SELECT 
    home_ownership,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS bad_loans,
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate_percentage
FROM financial_loan
GROUP BY home_ownership
ORDER BY default_rate_percentage DESC;

-- Loan Risk by Employment Length * This shows whether job stability affects default risk.
SELECT 
    emp_length,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS bad_loans,
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate_percentage
FROM financial_loan
GROUP BY emp_length
ORDER BY default_rate_percentage DESC;

-- DTI Risk Segmentation * This creates customer risk bands using debt-to-income ratio.
SELECT 
    CASE 
        WHEN dti < 10 THEN 'Low DTI'
        WHEN dti BETWEEN 10 AND 20 THEN 'Medium DTI'
        WHEN dti BETWEEN 20 AND 30 THEN 'High DTI'
        ELSE 'Very High DTI'
    END AS dti_risk_band,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS bad_loans,
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate_percentage
FROM financial_loan
GROUP BY dti_risk_band
ORDER BY default_rate_percentage DESC;

-- Interest Rate Risk Segmentation *This shows whether higher interest loans are more risky.
SELECT 
    CASE 
        WHEN int_rate < 10 THEN 'Low Interest'
        WHEN int_rate BETWEEN 10 AND 15 THEN 'Medium Interest'
        WHEN int_rate BETWEEN 15 AND 20 THEN 'High Interest'
        ELSE 'Very High Interest'
    END AS interest_risk_band,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS bad_loans,
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate_percentage
FROM financial_loan
GROUP BY interest_risk_band
ORDER BY default_rate_percentage DESC;

-- cleaning the date and year 
ALTER TABLE financial_loan
ADD COLUMN issue_date_clean DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE financial_loan
SET issue_date_clean = STR_TO_DATE(issue_date, '%d/%m/%Y');

SELECT issue_date, issue_date_clean
FROM financial_loan
LIMIT 10;

ALTER TABLE financial_loan
ADD COLUMN issue_year INT;

UPDATE financial_loan
SET issue_year = YEAR(issue_date_clean);

ALTER TABLE financial_loan
ADD COLUMN issue_month VARCHAR(20);

UPDATE financial_loan
SET issue_month = MONTHNAME(issue_date_clean);

ALTER TABLE financial_loan
ADD COLUMN month_number INT;

UPDATE financial_loan
SET month_number = MONTH(issue_date_clean);

SELECT
issue_date,
issue_date_clean,
issue_year,
issue_month,
month_number
FROM financial_loan
LIMIT 20;


-- Monthly Loan Disbursement Trend * This creates your monthly disbursement trend for Power BI.
SELECT 
    YEAR(issue_date_clean) AS year,
    MONTH(issue_date_clean) AS month,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed
FROM financial_loan
GROUP BY year, month
ORDER BY year, month;

-- Monthly Default Trend * This shows how default risk changes over time.
SELECT 
    YEAR(issue_date_clean) AS year,
    MONTH(issue_date_clean) AS month,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS bad_loans,
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate_percentage
FROM financial_loan
GROUP BY year, month
ORDER BY year, month;

-- Create Final Risk View for Power BI * This creates one clean dashboard-ready view.
CREATE OR REPLACE VIEW loan_risk_dashboard AS
SELECT 
    id,
    member_id,
    address_state,
    application_type,
    emp_length,
    emp_title,
    grade,
    sub_grade,
    home_ownership,
    issue_date,
    loan_status,
    purpose,
    term,
    verification_status,
    annual_income,
    dti,
    installment,
    int_rate,
    loan_amount,
    total_acc,
    total_payment,

    CASE 
        WHEN loan_status = 'Charged Off' THEN 'Bad Loan'
        WHEN loan_status IN ('Fully Paid', 'Current') THEN 'Good Loan'
        ELSE 'Other'
    END AS loan_category,

    CASE 
        WHEN dti < 10 THEN 'Low DTI'
        WHEN dti BETWEEN 10 AND 20 THEN 'Medium DTI'
        WHEN dti BETWEEN 20 AND 30 THEN 'High DTI'
        ELSE 'Very High DTI'
    END AS dti_risk_band,

    CASE 
        WHEN int_rate < 10 THEN 'Low Interest'
        WHEN int_rate BETWEEN 10 AND 15 THEN 'Medium Interest'
        WHEN int_rate BETWEEN 15 AND 20 THEN 'High Interest'
        ELSE 'Very High Interest'
    END AS interest_risk_band

FROM financial_loan;

-- Test the View * This checks whether the view works.
SELECT *
FROM loan_risk_dashboard
LIMIT 20;

-- Main Dashboard KPIs from the View
SELECT 
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(total_payment) AS total_collected,
    SUM(CASE WHEN loan_category = 'Bad Loan' THEN loan_amount ELSE 0 END) AS bad_loan_amount,
    ROUND(
        SUM(CASE WHEN loan_category = 'Bad Loan' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate_percentage
FROM loan_risk_dashboard;

USE financedb;

UPDATE financial_loan
SET 
    issue_date_clean = STR_TO_DATE(issue_date, '%d/%m/%Y'),
    issue_year = YEAR(STR_TO_DATE(issue_date, '%d/%m/%Y')),
    issue_month = MONTHNAME(STR_TO_DATE(issue_date, '%d/%m/%Y')),
    month_number = MONTH(STR_TO_DATE(issue_date, '%d/%m/%Y'));

DROP VIEW IF EXISTS loan_risk_dashboard;

CREATE VIEW loan_risk_dashboard AS
SELECT
    id,
    address_state,
    application_type,
    emp_length,
    emp_title,
    grade,
    home_ownership,
    issue_date,
    issue_date_clean,
    issue_year,
    issue_month,
    month_number,
    last_credit_pull_date,
    last_payment_date,
    loan_status,
    next_payment_date,
    member_id,
    purpose,
    sub_grade,
    term,
    verification_status,
    annual_income,
    dti,
    installment,
    int_rate,
    loan_amount,
    total_acc,
    total_payment,
    CASE
        WHEN loan_status = 'Charged Off' THEN 'Bad Loan'
        ELSE 'Good Loan'
    END AS loan_category
FROM financial_loan;

SELECT * FROM loan_risk_dashboard LIMIT 10;