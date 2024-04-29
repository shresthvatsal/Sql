CREATE TABLE customer1(
  cust_id VARCHAR(8) NOT NULL PRIMARY KEY,
  cust_name VARCHAR(20) not null,
  cust_age int not null,
  cust_address varchar(20) not null
  );

CREATE TABLE employee(
  stu_id int PRIMARY KEY,
  stu_state VARCHAR(20),
  student_city VARCHAR(20),
  cust_id varchar(8) ,
  Foreign key(cust_id) references customer1(cust_id)
);