USE financedb;

ALTER TABLE financial_loan
ADD COLUMN issue_date_clean DATE;

UPDATE financial_loan
SET issue_date_clean = STR_TO_DATE(issue_date, '%d/%m/%Y');

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

ALTER TABLE financial_loan
ADD COLUMN loan_category VARCHAR(50);

UPDATE financial_loan
SET loan_category =
CASE
    WHEN loan_status = 'Charged Off' THEN 'Bad Loan'
    ELSE 'Good Loan'
END;

ALTER TABLE financial_loan
ADD COLUMN recovery_status VARCHAR(50);

UPDATE financial_loan
SET recovery_status =
CASE
    WHEN total_payment >= loan_amount THEN 'Fully Recovered'
    WHEN total_payment > 0 AND total_payment < loan_amount THEN 'Partially Recovered'
    ELSE 'Not Recovered'
END;
