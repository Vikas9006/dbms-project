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
      RAISE NOTICE ‘Insufficient Balance’;
      Return null;
      else
      update Account set balance = balance + new.amount where account_number = new.receiver_id ;
update account set balance = balance - new.amount where account_number = new.sender_id;
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
      Select balance into f from Account where account_number = new.account_number;
      if f < new.withdrawal_amount then
      RAISE NOTICE ‘Insufficient Balance’;
      Return null;
      else
      update Account set balance = balance - new.withdrawal_amount where account_number = new.receiver_id ;
update account set balance = balance - new.withdrawal_amount  where account_number = new.account_number;
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