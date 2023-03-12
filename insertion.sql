INSERT INTO customer (customer_id, cust_name, cust_address, Aadhar_number, pan_number, income)
VALUES (1, 'Hari', 'colony', 111111111112, 1111111112, 1);

INSERT INTO transaction (sender_id, receiver_id, amount)
VALUES (11111112, 11111111, 100) , (11111112, 11111111, 200),
(11111113, 11111111, 300), (11111113, 11111111, 400);

INSERT INTO transaction (sender_id, receiver_id, amount)
VALUES (11111111, 11111112, 500) , (11111111, 11111113, 600);

INSERT INTO account (account_number)
VALUES (11111111), (11111112), (11111113);


-- create table loan (
--     loan_id int NOT NULL,
--     account_number int NOT NULL,
--     rate int check (rate > 0 and rate < 100) not null,
--     issued_amount int NOT NULL,
--     due_amount INT NULL,
--     issue_date TEXT NOT NULL,
--     foreign key (account_number) references account(account_number),
--     primary key (loan_id)
-- );

-- CREATE TABLE loan_repayment(
--     repayment_id SERIAL,
--     loan_id INT NOT NULL,
--     amount INT NOT NULL,
--     date TEXT NOT NULL,
--     PRIMARY KEY (repayment_id),
--     FOREIGN KEY (loan_id) REFERENCES loan(loan_id)
-- );

INSERT INTO loan (loan_id, account_number, rate, issued_amount, issue_date)
VALUES (1, 11111111, 100, 1000, '2008-10-02'::date);

INSERT INTO loan (loan_id, account_number, rate, issued_amount, issue_date)
VALUES (2, 11111112, 99.99, 10000, '2008-10-02'::date);


INSERT INTO loan_repayment (loan_id, amount, date)
VALUES (1, 200, '2009-10-03'::date);

INSERT INTO loan_repayment (loan_id, amount, date)
VALUES (2, 2000, '2011-10-03'::date);


