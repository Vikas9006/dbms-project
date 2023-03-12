-- add account procedure
CREATE or REPLACE procedure add_account(
   cust_id bigint
)
language plpgsql    
as $$
DECLARE cnt integer;
begin
    SELECT COUNT(*) FROM Account INTO cnt;
    INSERT INTO Account (account_number)
    VALUES (cnt);
    INSERT INTO holds (Aadhar_number, account_number)
    VALUES (cust_id, cnt);
    commit;
end;$$;

-- Function will return total bank balance considring transactions between accounts
CREATE OR REPLACE FUNCTION check_balance (acc_id int)
RETURNS INTEGER AS $total$
declare
	received INTEGER;
	rec_cnt INTEGER;
    sended INTEGER;
    sent_cnt INTEGER;
BEGIN
   SELECT SUM(amount) FROM transaction WHERE receiver_id = acc_id GROUP BY receiver_id into received;
   SELECT COUNT(*) FROM transaction WHERE receiver_id = acc_id into rec_cnt;
   SELECT SUM(amount) FROM transaction WHERE sender_id = acc_id GROUP BY sender_id into sended;
   SELECT COUNT(*) FROM transaction WHERE sender_id = acc_id into sent_cnt;
    IF rec_cnt = 0 THEN
        received = 0;
    END IF;
    IF sent_cnt = 0 THEN
        sended = 0;
    END IF;
   RETURN received - sended;
END;
$total$ LANGUAGE plpgsql;


-- loan from a brach id and name
SELECT branch_id, name, loan_amount
FROM branch natural join 
(SELECT branch_id, sum(issued_amount) as loan_amount
FROM has natural join loan group by branch_id) as foo;


-- Returns total number of employees with branch name
SELECT b.name AS branch_name, emp_cnt.cnt AS employee_count FROM 
(SELECT works.branchid, COUNT(*) AS cnt FROM
(SELECT b.branch_id AS branchid, b.address AS addr, e.employee_id AS empid
FROM branch b INNER JOIN employee e
ON b.branch_id = e.branch_id) as works GROUP BY works.branchid)
AS emp_cnt INNER JOIN branch b ON emp_cnt.branchid = b.branch_id;


-- all transactions related to a branch
SELECT b.branch_id, t.sender_id, t.receiver_id FROM branch b INNER JOIN Account a 
ON b.branch_id = a.branch_id INNER JOIN transaction t
ON a.account_number = t.sender_id OR a.account_number = t.receiver_id;


-- number of lockers per account number
SELECT account_number, COUNT(fd_id) AS count_lockers FROM (SELECT acc.account_number, haslocker.fd_id
FROM (SELECT fd.account_number, l.fd_id AS fd_id FROM fixed_deposit fd INNER JOIN locker l
ON fd.fd_id = l.fd_id) AS haslocker RIGHT OUTER JOIN account acc
ON haslocker.account_number = acc.account_number) AS acc_fd GROUP BY account_number;


-- number of atm cards corresponding to a branch id and branch name
SELECT branch_id, name, number_of_atm_cards 
FROM branch natural join 
(SELECT branch_id, count(atm_card_number) as number_of_atm_cards 
FROM has natural join supports group by branch_id) as foo;

-- last repayment date (if exists, otherwise return loan issue date)
CREATE OR REPLACE FUNCTION last_repay_date(lo_id INT)
RETURNS TEXT
LANGUAGE plpgsql
as
$$
DECLARE
    last_date TEXT;
    cnt INT;
BEGIN
    SELECT * FROM loan INNER JOIN loan_repayment
    ON loan.loan_id = loan_repayment.loan_id AND loan.loan_id = lo_id
    ORDER BY loan_repayment.date DESC LIMIT 1 INTO last_date;
    SELECT COUNT(*) FROM loan_repayment WHERE loan_id = lo_id INTO cnt;
    IF cnt = 0 THEN
        SELECT issue_date FROM loan WHERE loan_id = lo_id INTO last_date;
    END IF;
    RETURN last_date;
END;
$$;

-- Trigger to set due amount intially

CREATE OR REPLACE FUNCTION set_due_amount() RETURNS TRIGGER AS $$
    BEGIN
        UPDATE loan
        SET NEW.due_amount = NEW.issued_amount;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_due_amount AFTER INSERT ON loan
FOR EACH ROW EXECUTE PROCEDURE set_due_amount();

-- Trigger To update due_amount of loan after a repayment
CREATE OR REPLACE FUNCTION update_due_amount() RETURNS TRIGGER AS $$
    DECLARE
        l_id INT;
        last_date INT;
        curr_date INT;
        interest INT;
        due_amnt INT;
        new_amount INT;
        time INT;
    BEGIN
        -- Fetch loan id
        SELECT loan_id FROM NEW INTO l_id;
        SELECT last_repay_date(l_id) INTO last_date;
        SELECT date FROM NEW INTO curr_date;
        SELECT rate FROM loan WHERE loan_id = l_id INTO interest;
        SELECT due_amount FROM loan WHERE loan_id = l_id INTO due_amnt;
        SELECT DATE_PART('year', curr_date::date) - DATE_PART('year', last_date::date) INTO time;
        SELECT due_amount*(1 + (interest/100))^time INTO new_amount - NEW.amount;
        UPDATE loan
        SET due_amount = new_amount
        WHERE loan_id = l_id;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

SELECT DATE_PART('day', '2024-03-09'::timestamp - '2021-02-07'::timestamp);
SELECT DATE_PART('year', '2012-01-01'::date) - DATE_PART('year', '2008-10-02'::date);