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
-- remember it is not type (need to do)
color varchar not null ,
expiry_date date not null,
credit_card_issue_date date not null,
card_id int not null
,
foreign key (account_number) references Account(account_number) on update cascade on
delete cascade,
primary key (card_id));

create table fixed_deposit (
    open_date date NOT NULL,
    fd_id int NOT NULL,
    account_number int NOT NULL,
    interest float not null check (interest > 0),
    duration int not null,
    primary key (fd_id),
    foreign key (account_number) references Account(account_number)
);

create table locker (
locker_id int NOT NULL,
fd_id int,
issue_date date,
availability int NOT NULL,
size int NOT NULL,
foreign key (fd_id) references fixed_deposit(fd_id) on update cascade on
delete cascade,
primary key (locker_id));

CREATE TABLE transaction (
    transaction_id serial NOT NULL,
    sender_id bigint NULL,
    receiver_id bigint NULL,
    amount float NULL,
    date varchar(15),
    PRIMARY KEY (transaction_id),
    FOREIGN KEY (sender_id) REFERENCES Account(account_number),
    FOREIGN KEY (receiver_id) REFERENCES Account(account_number)
);

CREATE TABLE branch(
    branch_id serial NOT NULL,
    name varchar(15) NULL,
    address varchar(15) NULL,
    PRIMARY KEY (branch_id)
);

CREATE TABLE employee (
    employee_id serial NOT NULL,
    name varchar(15) NULL,
    address varchar(15) NULL,
    salary int NULL,
    branch_id int NOT NULL,
    dob varchar(15) NULL,
    PRIMARY KEY (employee_id),
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

ALTER TABLE account
ADD branch_id int;
