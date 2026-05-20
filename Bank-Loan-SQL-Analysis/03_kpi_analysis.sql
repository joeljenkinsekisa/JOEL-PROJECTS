USE financedb;

SELECT
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(total_payment) AS total_collected,
    ROUND(SUM(total_payment) / SUM(loan_amount) * 100, 2) AS collection_rate,
    ROUND(AVG(int_rate) * 100, 2) AS average_interest_rate,
    ROUND(AVG(dti), 2) AS average_dti
FROM financial_loan;
