-- add account
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

-- all account numbers which do not have kyc (i.e. pan number is null)
SELECT * FROM 