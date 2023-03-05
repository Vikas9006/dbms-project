select account_number from holds where aadhar_number=123;

CREATE VIEW detail AS (select credit_card.account_number, foo.atm_card_number, credit_card.card_id as credit_card_id from credit_card right outer join (select supports.account_number, supports.atm_card_number from supports right outer join (select account_number from holds where aadhar_number=123) as fpp on supports.account_number = fpp.account_number) as foo on foo.account_number = credit_card.account_number);

DROP VIEW detail;

CREATE VIEW locker_availability AS (select size, count(locker_id) from locker group by size having availability = 1);