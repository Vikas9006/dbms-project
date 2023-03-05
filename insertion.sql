INSERT INTO customer (customer_id, cust_name, cust_address, Aadhar_number, pan_number, income)
VALUES (1, 'Hari', 'colony', 111111111112, 1111111112, 1);

INSERT INTO transaction (sender_id, receiver_id, amount)
VALUES (11111112, 11111111, 100) , (11111112, 11111111, 200),
(11111113, 11111111, 300), (11111113, 11111111, 400);

INSERT INTO transaction (sender_id, receiver_id, amount)
VALUES (11111111, 11111112, 500) , (11111111, 11111113, 600);

INSERT INTO account (account_number)
VALUES (11111111), (11111112), (11111113);
