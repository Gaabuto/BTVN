create database session_06_db;
use session_06_db;

/*
	Employee, Department, Identify
    Employee 1:1 Identify
    Department 1:N Employee
*/
Create table Department(
	dept_id int primary key auto_increment,
    dept_name varchar(100) not null unique,
    dept_status bit default(1)
);
create table employee(
	emp_id char(4) primary key,
    emp_name varchar(100) not null,
    emp_age int check(emp_age>=18),
    emp_sex bit default(1),
    emp_salary decimal,
    emp_bod date,
    emp_status enum('active','inactive'),
    dept_id int,
    foreign key(dept_id) references Department(dept_id)
);
/*
	Để tạo liên kết 1:1 có 2 cách cài đặt:
		- Cách 1: Tạo 1 khóa ngoại ở 1 trong 2 bảng 
        và đặt rằng buộc là unique
        - Cách 2: Khóa ngoại đồng thời cũng là khóa chính
*/
-- Cách 1:
create table identify(
	identify_id int primary key auto_increment,
    identity_no char(12) not null,
    identity_created date,
    identity_placed varchar(200),
    identity_status bit default(1),
    emp_id char(4) unique,
    foreign key(emp_id) references Employee(emp_id)
);
-- Cách 2:
/*
create table identify(
	identify_id char(4) primary key,
    foreign key(identitfy_id) references Employee(emp_id),
    identity_no char(12) not null,
    identity_created date,
    identity_placed varchar(200),
    identity_status bit default(1)    
);
*/

INSERT INTO Department (dept_name, dept_status) VALUES
('HR', 1),
('IT', 1),
('Finance', 1),
('Marketing', 1),
('Operations', 0);

INSERT INTO Employee
(emp_id, emp_name, emp_age, emp_sex, emp_salary, emp_bod, emp_status, dept_id)
VALUES
('E001', 'Nguyen Van A', 25, 1, 1200.50, '1999-03-15', 'active', 1),
('E002', 'Tran Thi B', 28, 0, 1500.00, '1997-06-20', 'active', 2),
('E003', 'Le Van C', 35, 1, 2000.75, '1989-01-10', 'inactive', 3),
('E004', 'Pham Thi D', 22, 0, 1000.00, '2002-09-05', 'active', 2),
('E005', 'Hoang Van E', 30, 1, 1800.00, '1994-12-01', 'active', 4);

INSERT INTO identify
(identity_no, identity_created, identity_placed, identity_status, emp_id)
VALUES
('012345678901', '2018-01-01', 'Ha Noi', 1, 'E001'),
('012345678902', '2019-03-12', 'Hai Phong', 1, 'E002'),
('012345678903', '2017-07-20', 'Da Nang', 1, 'E003'),
('012345678904', '2020-11-05', 'TP HCM', 1, 'E004'),
('012345678905', '2016-05-30', 'Can Tho', 0, 'E005');


select e.emp_id, e.emp_name, e.emp_age,e.emp_salary,e.emp_status,d.dept_name,i.identity_no,i.identity_created,i.identity_placed
from employee e left join department d on e.dept_id = d.dept_id
				left join identify i on e.emp_id = i.emp_id;
                
select e.dept_id, sum(e.emp_salary)
from employee e
group by e.dept_id
having sum(e.emp_salary > 1500);

select e.dept_id, avg(emp_salary)
from employee e
group by e.dept_id
having avg(e.emp_salary > 800);