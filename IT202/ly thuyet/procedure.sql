
create database session11_db;
use session11_db;
create table student(
	student_id int primary key auto_increment,
    student_name varchar(100) not null,
    student_age int check(student_age >=18),
    student_score decimal,
    student_status enum('active','pending','reject')
);
/*
	PROCEDURE:
    syntax:
		DELIMITER // -- phân tách vùng nhớ để lưu procedure
		CREATE PROCEDURE [pro_name](IN|OUT|INOUT param_name datatype)
			BEGIN
				Block statements; -- Thực thi chức năng của procedure
            END //
        DELIMITER ;
*/	
-- CRUD: Create - Read - Update - Delete	
-- 1. Tạo 1 procedure cho phép thêm mới 1 sinh viên (Create)
DELIMITER //
Create procedure create_student(
	IN name_in varchar(100),
    age_in int,
    score_in decimal,
    status_in enum('active','pending','reject')
)
BEGIN
	insert into Student(student_name,student_age,student_score, student_status)
    values(name_in, age_in, score_in, status_in);
END //
DELIMITER ;
call create_student('Nguyễn Văn An', 19, 8.2, 'active');
select * from student;
-- 2. Tạo procedure cho phép lấy thông tin các sinh viên (Read)
DELIMITER //
Create procedure find_all_student()
BEGIN
	select * from student;
END //
DELIMITER ;
call find_all_student();
-- 3. Tạo procedure cho phép cập nhật thông tin 1 sinh viên
DELIMITER //
create procedure update_student(
	id_in int,
    name_in varchar(100),
    age_in int,
    score_in decimal,
    status_in enum('active','pending','reject')
)
BEGIN
	Update student
	set student_name = name_in,
		student_age = age_in,
        student_score = score_in,
        student_status = status_in
	where student_id = id_in;
END //
DELIMITER ;
call update_student(1,'Nguyễn Văn Bình',20, 5.5, 'pending');
-- 4. Viết procedure cho phép xóa sinh viên
DELIMITER //
create procedure delete_student(id_in int)
BEGIN
	delete from student where student_id = id_in;
END //
DELIMITER ;
call delete_student(1);
-- 5. Viết procedure cho phép lấy thông tin sinh viên theo mã sinh viên
DELIMITER //
create procedure find_student_by_id(id_in int)
BEGIN
	select * from student where student_id = id_in;
END //
DELIMITER ;
call find_student_by_id(1);
-- 6. Viết procedure lấy số lượng sinh viên trong bảng sinh viên
DELIMITER //
create procedure get_count_student(OUT cnt_student int)
BEGIN
	select count(s.student_id) into cnt_student
    from student s;
END //
DELIMITER ;
call get_count_student(@cnt);
select @cnt;
-- 7. Cập nhật điểm cho sinh viên theo mã sinh viên (%), thực hiện xong trả ra điểm vừa cập nhật
drop procedure if exists update_student_score;
DELIMITER //
create procedure update_student_score(id_in int, INOUT score decimal)
BEGIN	
	update student
    set student_score = student_score * score
    where student_id = id_in;
    select s.student_score into score from student s where student_id = id_in;
END //
DELIMITER ;
drop procedure if exists test_param_in_out;
DELIMITER //
create procedure test_param_in_out(OUT score decimal)
BEGIN
	-- Khai báo biến (trong procedure)
    declare value_in decimal;
    -- Gán giá trị cho biến
    set value_in = 2;
    call update_student_score(1,value_in);    
    set score = value_in;
END //
DELIMITER ;
call test_param_in_out(@score);
select @score;
