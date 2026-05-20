--Monthly disbursement trend
SELECT
    issue_month,
    SUM(loan_amount) AS total_disbursed
FROM financial_loan
GROUP BY issue_month, month_number
ORDER BY month_number;

--Monthly collection trend
SELECT
    issue_month,
    SUM(total_payment) AS total_collected
FROM financial_loan
GROUP BY issue_month, month_number
ORDER BY month_number;

--Disbursed vs collected monthly
SELECT
    issue_month,
    SUM(loan_amount) AS total_disbursed,
    SUM(total_payment) AS total_collected,
    ROUND(SUM(total_payment) / SUM(loan_amount) * 100, 2) AS collection_rate
FROM financial_loan
GROUP BY issue_month, month_number
ORDER BY month_number;

--interest revenue by purpose
SELECT
    purpose,
    SUM(loan_amount * int_rate) AS estimated_interest
FROM financial_loan
GROUP BY purpose
ORDER BY estimated_interest DESC;

--Collection rate by grade
SELECT
    grade,
    SUM(loan_amount) AS total_disbursed,
    SUM(total_payment) AS total_collected,
    ROUND(SUM(total_payment) / SUM(loan_amount) * 100, 2) AS collection_rate
FROM financial_loan
GROUP BY grade
ORDER BY grade;

---Recovery status
SELECT
    recovery_status,
    COUNT(*) AS total_loans,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM financial_loan), 2) AS percentage_of_total
FROM financial_loan
GROUP BY recovery_status;

Top 10 states by collection
SELECT
    address_state,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(total_payment) AS total_collected,
    ROUND(SUM(total_payment) / SUM(loan_amount) * 100, 2) AS collection_rate
FROM financial_loan
GROUP BY address_state
ORDER BY total_collected DESC
LIMIT 10;


