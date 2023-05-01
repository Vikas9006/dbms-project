– index for transaction table -: 


create index idx_transaction_sender_id on transaction using btree(sender_id);


create index idx_transaction_receiver_id on transaction using btree(receiver_id);




-index on loan table


create index idx_loan_loan_id on loan using btree(loan_id);


-index on loan_repayment table -: 


create index idx_loan_repayment_repayment_id on loan_repayment using btree(repayment_id);




-index on Account table-: 


create index idx_Account_account_number on Account using btree(account_number);