-- Loan status breakdown
SELECT
    loan_status,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(total_payment) AS total_collected
FROM financial_loan
GROUP BY loan_status
ORDER BY total_loans DESC;

--Good loan vs bad loan
SELECT
    loan_category,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_disbursed,
    SUM(total_payment) AS total_collected,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM financial_loan), 2) AS percentage_of_loans
FROM financial_loan
GROUP BY loan_category;

--Default rate
SELECT
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate
FROM financial_loan;

--Default rate by grade
SELECT
    grade,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS bad_loans,
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate
FROM financial_loan
GROUP BY grade
ORDER BY grade;

--Risk by purpose
SELECT
    purpose,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN loan_amount ELSE 0 END) AS bad_loan_amount,
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate
FROM financial_loan
GROUP BY purpose
ORDER BY bad_loan_amount DESC;

--Top 10 states by default rate
SELECT
    address_state,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS bad_loans,
    ROUND(
        SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS default_rate,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN loan_amount ELSE 0 END) AS bad_loan_amount
FROM financial_loan
GROUP BY address_state
HAVING COUNT(*) >= 50
ORDER BY default_rate DESC
LIMIT 10;


