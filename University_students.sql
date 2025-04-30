create database university_students;

select * from students;

desc students;
-- As seen, there is difference data type for some rows in table. Let's change them!

alter table students
modify first_name varchar(50);

alter table students
modify last_name varchar(50);

select distinct gender from students;
-- As see, there are 9 distinct values on gender row. 
-- However, I need only two values - male and female.
-- That's why, I will write male and female instead of other distinct values. 

update students set gender = 'Male' 
where gender in ('Agender', 'Polygender', 'Genderfluid');

update students set gender = 'Female' 
where gender in ('Bigender', 'Genderqueer', 'Non-binary');

select distinct gender from students;

alter table students
modify gender enum ('Male', 'Female');

-- As seen, "birth_date" column is text data type. Thus I should change its type.
-- Firstly, I addded new column named "birth_date_converted". Then I modified it. 
alter table  students
add column birth_date_converted date;

update students
set birth_date_converted = str_to_date(birth_date, '%d.%m.%Y')
where str_to_date(birth_date, '%d.%m.%Y') is not null;

alter table  students drop column birth_date;
alter table students change birth_date_converted birth_date DATE;

alter table students
modify birth_date date after gender;

alter table students
modify major varchar(100);

alter table students
modify country varchar(50);

desc students;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
select * from courses;

desc courses;

alter table courses
modify course_name varchar(100);

alter table courses
modify course_code varchar(10);

alter table courses
modify semester varchar(10);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
select * from attendance;

desc attendance;

-- As seen, "attendance_date" column is text data type. Thus I should change its type.
-- Firstly, I addded new column named "attendance_date_converted". Then I modified it. 
alter table attendance
add column attendance_date_converted date;

update attendance
set attendance_date_converted = str_to_date(attendance_date, '%d.%m.%Y')
where str_to_date(attendance_date, '%d.%m.%Y') is not null;

alter table attendance
drop column attendance_date;

alter table attendance
change attendance_date_converted attendance_date date;

alter table attendance
modify attendance_date date after course_id;

-- When I checked distinct values on "status" column, there were 3 distinct values; Present, Absent and Late
-- I replaced count of "late" with "absent" 
select distinct status from attendance;

select status, count(*) as total from attendance
group by status;

update attendance
set status = 'Absent' where status = 'Late';

alter table attendance
modify status enum('Present','Absent');

desc attendance;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
select * from grades;

desc grades;

-- As seen, "grade_date" column is text data type. Thus I should change its type.
-- Firstly, I addded new column named "grade_date_converted". Then I modified it. 
alter table grades
add column grade_date_converted date;

update grades
set grade_date_converted = str_to_date(grade_date, '%d.%m.%Y')
where str_to_date(grade_date, '%d.%m.%Y') is not null;

alter table grades
drop column grade_date;

alter table grades
change grade_date_converted grade_date date;

alter table grades
modify grade_date date after grade;

alter table grades
modify exam_type varchar(10);

desc grades;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- In this project, a student can enroll in multiple courses,
-- and each course can have multiple students enrolled. This is a classic many-to-many relationship.

-- To properly model this relationship, we create a junction table
-- called "student_courses".

-- Each row in this table represents one enrollment:it links a student to a course they are enrolled in.

-- This structure helps normalize the database and keeps
-- the "students" and "courses" tables clean and focused only on their respective data.

create table  student_courses (
  student_id int not null,
  course_id int not null
  );
  
insert into student_courses (student_id, course_id)
select student_id, course_id from courses;

alter table student_courses
modify student_id int after course_id;

alter table courses
drop column student_id;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- Primary keys added to ensure unique rows
alter table students
modify student_id int not null,
add primary key (student_id);

alter table courses
modify course_id int not null,
add primary key (course_id);

alter table student_courses
modify course_id int not null,
modify student_id int not null,
add primary key (course_id, student_id);

alter table attendance
modify attendance_id int not null,
add primary key (attendance_id);

alter table grades
modify grade_id int not null,
add primary key (grade_id);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- To add foreign keys to tables

-- Adding foreign keys to "student_courses" table
alter table student_courses
add constraint fk_student_courses_student
foreign key (student_id) references students(student_id);

alter table student_courses
add constraint fk_student_courses_course
foreign key (course_id) references courses(course_id);

-- Adding foreign keys to attendance table
alter table attendance
add constraint fk_attendance_student
foreign key (student_id) references students(student_id);

alter table attendance
add constraint fk_attendance_course
foreign key (course_id) references courses(course_id);

-- Adding foreign keys to grades table
alter table grades
add constraint fk_grades_student
foreign key (student_id) references students(student_id);

alter table grades
add constraint fk_grades_course
foreign key (course_id) references courses(course_id);
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Question 1: Show number of students and their average GPA by country
select 
	country,
    count(*) as student_count,
    round(avg(gpa), 2) as average_gpa
from students 
group by country
order by average_gpa desc;

-- Question 2: Compare students’ attendance across semesters along with the total course credits taken
select 
    s.student_id,
    s.first_name,
    s.last_name,
    c.semester,
    count(a.status) as total_present,
    sum(c.credits) as total_credits
from students s
join attendance a 
	on s.student_id = a.student_id
join courses c 
	on a.course_id = c.course_id
where a.status = 'Present'
group by s.student_id, s.first_name, s.last_name, c.semester
order by s.student_id, c.semester;

-- Question 3: Which students have poor attendance records?
select 
    s.student_id,
    s.first_name,
    s.last_name,
    count(a.attendance_id) as total_classes,
    sum(case when a.status = 'Present' then 1 else 0 end) as present_count,
    round((sum(case when a.status = 'Present' then 1 else 0 end) / count(a.attendance_id)) * 100, 2) as attendance_rate
from students s
join attendance a 
    on s.student_id = a.student_id
group by s.student_id, s.first_name, s.last_name
having attendance_rate < 70;
    
-- Question 4: Which courses have the highest number of missed classes?
select 
    c.course_name,
    count(a.status) as missed_classes
from attendance a
join courses c 
	on a.course_id = c.course_id
where a.status = 'Absent' 
group by 
    c.course_name
order by missed_classes desc;

-- Question 5: Show average GPA and total enrolled courses per semester
select 
	c.semester,
    count(distinct s.student_id) as total_students,
    round(avg(s.gpa), 2) as average_gpa,
    sum(s.course_count) as total_courses_taken
from students s
join student_courses sc
	on s.student_id = sc.student_id 
join courses c
	on sc.course_id = c.course_id
group by c.semester
order by c.semester;

-- Question 6: How has enrollment (enrollment_year) increased or decreased over the years?
select 
	enrollment_year,
    count(*) as student_count
from students
group by enrollment_year
order by enrollment_year;

-- Question 7: Which students have a GPA above their major’s average?
select 
    s.student_id,
    s.first_name,
    s.last_name,
    s.major,
    s.gpa,
    m.avg_gpa
from students s
join (
    select 
        major, 
        round(avg(gpa), 2) as avg_gpa
    from students
    group by major
) m on s.major = m.major
where s.gpa > m.avg_gpa;

-- Question 8: Which students have enrolled in courses with the highest total credit load?
select 
    s.student_id,
    concat(s.first_name, ' ', s.last_name) as student_name,
    sum(c.credits) as total_credits
from student_courses sc
join courses c 
	on sc.course_id = c.course_id
join students s 
	on sc.student_id = s.student_id
group by 
    s.student_id, s.first_name, s.last_name
order by 
    total_credits desc;

-- Question 9: Identify which courses students struggle with the most
select 
	c.course_name,
    c.course_code,
    round(avg(g.grade), 2) as average_grade,
    count(g.student_id) as student_count
from grades g
join courses c
	on g.course_id = c.course_id
group by course_name, c.course_code
order by average_grade asc;

-- Question 10: Show each student’s GPA, the number of enrolled courses, and the average credit of those courses using a subquery.

select 
    s.student_id,
    concat(s.first_name, ' ', s.last_name) as student_name,
    s.gpa,
    (select count(*)  from student_courses sc where sc.student_id = s.student_id) as enrolled_courses,
    (select round(avg(c.credits), 2) from student_courses sc 
		join courses c on sc.course_id = c.course_id
        where sc.student_id = s.student_id) as average_course_credit
from students s;

-- Question 11: What is the academic performance of students with the highest course load?
select 
    s.student_id,
    concat(s.first_name, ' ', s.last_name) as full_name,
    s.course_count,
    s.gpa,
    round(avg(g.grade), 2) as avg_grade
from students s
join grades g 
	on s.student_id = g.student_id
where s.course_count = (select max(course_count) from students)
group by s.student_id, full_name, s.course_count, s.gpa;

-- Question 12: How does attendance rate vary by gender and country?
select 
    s.gender,
    s.country,
    round(sum(case when a.status = 'Present' then 1 else 0 end) / count(*) * 100, 2) as attendance_rate
from students s
join attendance a 
	on s.student_id = a.student_id
group by s.gender, s.country
order by attendance_rate desc;









