-- add account procedure
CREATE or REPLACE procedure add_account(
   cust_id int,
   branch_id INT
)
language plpgsql 
as $$
DECLARE acno INTEGER;
begin
    INSERT INTO Account (branch_id, isOpen, balance)
    VALUES (branch_id, TRUE, 0) RETURNING account_number INTO acno;
    INSERT INTO holds (Aadhar_number, account_number)
    VALUES (cust_id, acno);
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
RETURNS DATE
LANGUAGE plpgsql
as
$$
DECLARE
    last_date DATE;
    cnt INT;
BEGIN
    SELECT date FROM loan INNER JOIN loan_repayment
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
        SET due_amount = NEW.issued_amount WHERE loan_id = NEW.loan_id;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER set_due_amount AFTER INSERT ON loan
FOR EACH ROW EXECUTE PROCEDURE set_due_amount();

-- Trigger To update due_amount of loan after a repayment
CREATE OR REPLACE FUNCTION update_due_amount() RETURNS TRIGGER AS $$
    DECLARE
        l_id INT;
        last_date DATE;
        curr_date DATE;
        interest FLOAT;
        due_amnt INT;
        new_amount INT;
        applied_interest INT;
        time INT;
    BEGIN
        -- Fetch loan id
        SELECT loan_id FROM loan_repayment WHERE repayment_id = NEW.repayment_id INTO l_id;
        SELECT last_repay_date(l_id) INTO last_date;
        SELECT date FROM loan_repayment WHERE repayment_id = NEW.repayment_id INTO curr_date;
        SELECT rate FROM loan WHERE loan_id = l_id INTO interest;
        SELECT due_amount FROM loan WHERE loan_id = l_id INTO due_amnt;
        SELECT DATE_PART('year', curr_date::date) - DATE_PART('year', last_date::date) INTO time;
        SELECT due_amnt *(1 + (interest/100))^time INTO applied_interest;
        SELECT due_amnt + applied_interest - NEW.amount INTO new_amount;
        UPDATE loan
        SET due_amount = new_amount
        WHERE loan_id = l_id;
        RETURN NEW;       
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_due_amount AFTER INSERT ON loan_repayment
FOR EACH ROW EXECUTE PROCEDURE update_due_amount();

-- SELECT DATE_PART('day', '2024-03-09'::timestamp - '2021-02-07'::timestamp);
-- SELECT DATE_PART('year', '2012-01-01'::date) - DATE_PART('year', '2008-10-02'::date);



ALTER TABLE account
ADD balance float;

create or replace function update_amount_function()
    returns trigger
language plpgsql
as $f$
declare
    f float ;
Begin
    Select balance into f from Account where account_number = new.sender_id;
    if f < new.amount then
        RAISE NOTICE 'Insufficient Balance';
        Return null;
    else
        update Account set balance = balance + new.amount where
        account_number = new.receiver_id ;
        update account set balance = balance - new.amount where
        account_number = new.sender_id;
    Return new;
End if;
END;
$f$;

Create trigger update_transaction_trigger
After insert
On transaction
For each row
Execute procedure update_amount_function() ;
Create table deposit
(
deposit_id serial not null,
account_number int not null,
amount float NULL,
Primary key (deposit_id),
FOREIGN KEY ( account_number) references Account (account_number)
);
Create or replace function deposit_trigger_function()
Returns trigger
Language plpgsql
As $$
Begin
update account
set balance = balance + new.amount
where account_number = new.account_number ;
Return new;
End;
$$;
Create trigger deposit_trigger
After insert
On deposit
For each row
Execute procedure deposit_trigger_function();
Create table withdrawal
(
withdrawal_id serial not null,
account_number int not null,
withdrawal_amount float NULL,
Primary key (withdrawal_id),
FOREIGN KEY ( account_number) references Account (account_number)
);
create or replace function withdrawal_trigger_function()
returns trigger
language plpgsql
as $f$
declare
f float ;
Begin
Select balance into f from Account where account_number =
new.account_number;
if f < new.withdrawal_amount then
RAISE NOTICE ‘Insufficient Balance’;
Return null;
else
update Account set balance = balance - new.amount where
account_number = new.receiver_id ;
update account set balance = balance - new.amount where
account_number = new.account_number;
Return new;
End if;
END;
$f$;
Create trigger withdrawal_trigger
After insert
On withdrawal
For each row
Execute procedure withdrawl_trigger_function()
;