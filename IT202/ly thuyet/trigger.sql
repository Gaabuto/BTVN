create database ss13;
use ss13;
create table categories(
catalog_id int primary key auto_increment,
catalog_names varchar(100) not null unique,
catalog_status bit default(1)
);

create table products(
product_id char(4) primary key,
catalog_id int,
product_name varchar(100) not null unique,
product_price float not null,
product_status bit default(1),
foreign key(catalog_id) references categories(catalog_id)
);
insert into categories(catalog_names)
values
('Quan ao'), ('trang suc');

insert into products
values
('P001',1, 'Ao so mi', 10, 1),
('P002',2, 'nhan kim cuong', 1000000, 1);


delimiter //
create trigger before_insert_product
before insert
on products for each row
begin
if new.product_price <= 0 then
	signal sqlstate '45000'
    set message_text = 'Khong the them san pham voi gia <= 0';
end if;
end //
delimiter ;


insert into products
values
('P003',2, 'sieu kc', -3, 1);

delimiter //
create trigger before_delete_product
before delete
on products for each row
begin
if old.product_id = 'P001' then 
signal sqlstate '45000'
set message_text = 'khong the xoa san pham P001';
end if;
end //
delimiter ;

delete from products where product_id = 'P001'; 

delimiter //
create trigger before_insert_product_2 
before insert
on products for each row
begin
declare check_categories int default 0;
select count(c.catalog_id) into check_categories from categories c where c.catalog_id = new.catalog_id;
if check_categories = 0 then
insert into categories(catalog_id, catalog_name)
values(new.catalog_id, test);
end if;
end //
delimiter ;

insert into products
values('P003',3,'Áo polo', 30, 1);