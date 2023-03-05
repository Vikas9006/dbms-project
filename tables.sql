-- ANS1 -: CREATING ACCOUNT TABLE -:

create table Account
(
account_number int NOT NULL check (account_number >= 11111111),
primary key(account_number)
);

-- Ans2 -: creating customer table -:

create table customer
(
customer_id int not null check(customer_id > 0),
cust_name char(50) not null,
cust_address char(50) null,
Aadhar_number bigint not null check(Aadhar_number > 111111111111),
pan_number bigint not null check(pan_number > 1111111111),
income int not null check(income > 0),
primary key (Aadhar_number)
);

-- ANS3 -: CREATING HOLDS TABLE:

create table holds
(
Aadhar_number bigint not null check(Aadhar_number > 111111111111),
account_number int NOT NULL check (account_number >= 11111111),
foreign key(Aadhar_number)
references customer(Aadhar_number) on update cascade on delete cascade,
foreign key(account_number)
references Account(account_number) on update cascade on delete cascade,
primary key (Aadhar_number,account_number));

-- Ans4 -: CREATING atm card table -:

create table atm_card(
issue_date date not null ,
account_number int NOT NULL check (account_number >= 11111111),
atm_card_number bigint not null check(atm_card_number >= 1111111111111111),
foreign key(account_number) references Account(account_number) on update cascade on
delete cascade,
primary key (atm_card_number));

-- Ans5 -: creating supports table -:

create table supports (
account_number int NOT NULL check (account_number >= 11111111),
atm_card_number bigint not null check(atm_card_number >= 1111111111111111),
foreign key(account_number) references Account(account_number) on update cascade on
delete cascade,
foreign key(atm_card_number) references atm_card(atm_card_number) on update cascade on
delete cascade,
primary key(atm_card_number));

-- Ans 6-: creating credit card table -:

create table credit_card (
account_number int NOT NULL check (account_number >= 11111111),
card_limit bigint not null check (card_limit > 0 and card_limit <= 50000000),
type color not null ,
expiry_date date not null,
credit_card_issue_date date not null,
card_id int not null
,
foreign key (account_number) references Account(account_number) on update cascade on
delete cascade,
primary key (card_id));