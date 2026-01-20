/*
comment nhieu dong
*/
-- comment 1 dong
-- ket thuc cau lenh dung ;
/*DDL- Data Defination Language
Create obj_name: tao moi doi tuong
Drop obj_name: xoa doi tuong
Alter obj_name: sua doi tuong
*/

/*
Create Database database_name: tao 1 co so du lieu
use database_name: chon cso du lieu
Drop database database_name : sua cau truc 1 doi tuong
*/

create database if not exists it3_database;
use it3_database;
drop database it3_database;

create table categories(
category_id int primary key auto_increment,
category_name varchar(100) not null unique,
category_description text not null,
category_status bit default(1)
);
create table products(
product_id char(5) primary key,
product_name varchar(50) not null unique,
product_price float not null check(product_price > 0),
product_title text,
category_id int,
foreign key(category_id) references categories(category_id),
product_status enum('dang ban','het hang','khong ban')
);
-- add cot vao bang
alter table categories
add column category_priority int not null;
-- sua cot trong bang
alter table categories
modify column category_priority varchar(100);
-- xoa cot trong bang
alter table categories
drop column category_priority;
-- doi ten cot trong bang
alter table categories
rename column category_description to descriptionz;
 