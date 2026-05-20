CREATE DATABASE IF NOT EXISTS financedb;
USE financedb;

DROP TABLE IF EXISTS financial_loan;

CREATE TABLE financial_loan (
    id INT,
    address_state VARCHAR(10),
    application_type VARCHAR(50),
    emp_length VARCHAR(50),
    emp_title VARCHAR(255),
    grade VARCHAR(10),
    home_ownership VARCHAR(50),
    issue_date VARCHAR(20),
    last_credit_pull_date VARCHAR(20),
    last_payment_date VARCHAR(20),
    loan_status VARCHAR(50),
    next_payment_date VARCHAR(20),
    member_id BIGINT,
    purpose VARCHAR(100),
    sub_grade VARCHAR(10),
    term VARCHAR(50),
    verification_status VARCHAR(50),
    annual_income DECIMAL(15,2),
    dti DECIMAL(10,2),
    installment DECIMAL(10,2),
    int_rate DECIMAL(10,4),
    loan_amount DECIMAL(15,2),
    total_acc INT,
    total_payment DECIMAL(15,2)
);
