SELECT
    loan_status,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(total_payment) AS total_collected
FROM financial_loan
GROUP BY loan_status
ORDER BY total_loans DESC;
