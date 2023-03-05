select account_number from holds where aadhar_number=123;

CREATE VIEW detail AS (select credit_card.account_number, foo.atm_card_number, credit_card.card_id as credit_card_id from credit_card right outer join (select supports.account_number, supports.atm_card_number from supports right outer join (select account_number from holds where aadhar_number=123) as fpp on supports.account_number = fpp.account_number) as foo on foo.account_number = credit_card.account_number);

DROP VIEW detail;

CREATE VIEW locker_availability AS (select size, availability, count(locker_id) from locker group by size, availability );

CREATE ROLE employee;
CREATE ROLE customer;
grant select, update, insert, delete on Account, locker, supports, holds, customer to employee;
grant select on locker_availability to customer;
CREATE ROLE emp1 LOGIN PASSWORD 'emp1';
GRANT employee to emp1;
CREATE ROLE cust1 LOGIN PASSWORD 'cust1';
GRANT select on detail to cust1;
GRANT customer to cust1;