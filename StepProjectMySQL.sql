/*1. Покажіть середню зарплату співробітників за кожен рік, до 2005 року.*/

/*USE employees;

SELECT YEAR(from_date) AS YearSal,
		ROUND(AVG(salary),2) AS AvgSal
FROM employees.salaries
GROUP BY YearSal
HAVING YearSal BETWEEN MIN(YearSal) AND 2005
ORDER BY AvgSal DESC;*/

/*2. Покажіть середню зарплату співробітників по кожному відділу. 
Примітка: потрібно розрахувати по поточній зарплаті, та поточному відділу співробітників*/

/*SELECT demp.dept_no AS DepEmp,
		ROUND(AVG(sal.salary),2) AS AvgSal
FROM employees.employees emp
INNER JOIN employees.salaries sal
ON emp.emp_no = sal.emp_no AND CURRENT_DATE BETWEEN sal.from_date AND sal.to_date
INNER JOIN employees.dept_emp demp
ON sal.emp_no = demp.emp_no AND CURRENT_DATE BETWEEN demp.from_date AND demp.to_date
GROUP BY DepEmp;*/

 
/*3. Покажіть середню зарплату співробітників по кожному відділу за кожний рік*/

/*SELECT  demp.dept_no AS DepNum,
		dep.dept_name AS DepName,
		YEAR(sal.from_date) AS YearSal,
		ROUND(AVG(sal.salary),2) AS AvgSal
FROM employees.salaries sal
INNER JOIN employees.dept_emp demp
ON sal.emp_no = demp.emp_no
INNER JOIN employees.departments dep
ON demp.dept_no = dep.dept_no
GROUP BY DepNum, YearSal
ORDER BY DepNum;*/

/*4. Покажіть відділи в яких зараз працює більше 15000 співробітників.*/

/*SELECT dept.dept_name,
		COUNT(demp.emp_no) AS EmployeesCount
FROM employees.dept_emp demp
INNER JOIN employees.departments dept
ON demp.dept_no = dept.dept_no
WHERE CURRENT_DATE() BETWEEN from_date AND to_date
GROUP BY dept.dept_name
HAVING EmployeesCount >= 15000;*/

/*5. Для менеджера який працює найдовше покажіть його номер,
 відділ, дату прийому на роботу, прізвище*/

/*SELECT dmng.emp_no,
		emp.last_name,
        dept.dept_name,
		emp.hire_date
FROM employees.employees emp
INNER JOIN employees.dept_manager dmng
ON emp.emp_no = dmng.emp_no AND dmng.to_date > CURDATE()
INNER JOIN employees.departments dept
ON dmng.dept_no = dept.dept_no
ORDER BY emp.hire_date ASC
LIMIT 1;*/


/*6. Покажіть топ-10 діючих співробітників компанії з найбільшою різницею між їх зарплатою і середньою зарплатою в їх відділі.*/

/*WITH cte_deptavg_sal AS
(
	SELECT demp.dept_no,
			ROUND(AVG(sal.salary),2) AS avg_salary
	FROM employees.dept_emp demp
	INNER JOIN employees.salaries sal
	ON demp.emp_no = sal.emp_no AND CURRENT_DATE BETWEEN sal.from_date AND sal.to_date
	WHERE  CURRENT_DATE BETWEEN demp.from_date AND demp.to_date
	GROUP BY demp.dept_no
),
cte_emp_salary AS 
(	
	SELECT emp.emp_no,
			emp.first_name,
            emp.last_name,
            demp.dept_no,
            sal.salary
    FROM employees.employees emp
    INNER JOIN employees.dept_emp demp
    ON emp.emp_no = demp.emp_no AND CURRENT_DATE BETWEEN demp.from_date AND demp.to_date
    INNER JOIN employees.salaries sal
    ON demp.emp_no = sal.emp_no AND CURRENT_DATE BETWEEN sal.from_date AND sal.to_date
    )
	SELECT es.emp_no,
			es.first_name,
            es.last_name,
            es.dept_no,
            es.salary,
            da.avg_salary,
            ROUND(es.salary - da.avg_salary,2) AS diff_salary
    FROM cte_emp_salary es
    INNER JOIN cte_deptavg_sal da
    ON es.dept_no = da.dept_no
	ORDER BY ABS(es.salary - da.avg_salary) DESC
    LIMIT 10;*/


/*7. Для кожного відділу покажіть другого по порядку менеджера. 
Необхідно вивести відділ, прізвище ім’я менеджера, дату прийому на роботу менеджера
та дату коли він став менеджером відділу*/

/*CREATE TEMPORARY TABLE t_dmng
AS 
SELECT dmng.dept_no,
		dep.dept_name,
		emp.first_name,
        emp.last_name,
        emp.hire_date,
        dmng.from_date AS start_mng_date, 
        ROW_NUMBER() OVER (PARTITION BY dmng.dept_no ORDER BY dmng.dept_no, dmng.from_date) AS SecondMng
FROM employees.dept_manager dmng
INNER JOIN employees.employees emp
ON dmng.emp_no = emp.emp_no 
INNER JOIN employees.departments dep
ON dmng.dept_no = dep.dept_no;

SELECT *
FROM t_dmng
WHERE SecondMng = 2;

DROP TEMPORARY TABLE t_dmng;*/


/*---- створення БД: ------*/

/*DROP DATABASE IF EXISTS CoursesDB;
CREATE DATABASE IF NOT EXISTS  CoursesDB;
USE CoursesDB;*/

/*CREATE TABLE IF NOT EXISTS courses(
	course_no INT AUTO_INCREMENT PRIMARY KEY,
	course_name VARCHAR(255) NOT NULL,
	start_date DATE,
	end_date DATE
);
DROP TABLE IF EXISTS courses; "це зайве просто писав для себе "
DESCRIBE courses;*/

/* -- тут я вирішив змінити ключі, щоб ключі в курсах відрізнялись.---*/
/*ALTER TABLE courses AUTO_INCREMENT = 101;*/

/*CREATE TABLE IF NOT EXISTS teachers(
	 teacher_no INT AUTO_INCREMENT PRIMARY KEY,
	 teacher_name VARCHAR(100) NOT NULL,
	 phone_no VARCHAR(20)
);
DROP TABLE IF EXISTS teachers; "це зайве просто писав для себе "
DESCRIBE teachers;

CREATE TABLE IF NOT EXISTS students (
    student_no INT AUTO_INCREMENT PRIMARY KEY,
    teacher_no INT NOT NULL,
    course_no INT NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    birth_date DATE,
    FOREIGN KEY (teacher_no) REFERENCES teachers(teacher_no),
    FOREIGN KEY (course_no) REFERENCES courses(course_no)
);
DROP TABLE IF EXISTS students; "це зайве просто писав для себе "
DESCRIBE students;*/

/* ---- Заповеюємо таблиці ----*/

/*START TRANSACTION;

INSERT INTO teachers (teacher_name, phone_no) VALUES
('Іван Петренко', '380501234567'),
('Марія Іваненко', '380671112233'),
('Олександр Коваль', '380931234567'),
('Ольга Гусак', '380934568893'),
('Світлана Мороз', '380951112244'),
('Андрій Шевченко', '380503334455'),
('Катерина Бондар', '380673456789'),
('Василь Соловей', '380931119988');

INSERT INTO courses (course_name, start_date, end_date) VALUES
('Програмування на Python', '2025-09-01', '2025-12-20'),
('Бази даних SQL', '2025-09-15', '2025-12-30'),
('Веб-розробка', '2025-10-01', '2026-01-15'),
('3D-Дизайн', '2025-01-20', '2026-02-20'),
('Машинне навчання', '2025-11-01', '2026-03-01'),
('Мережеві технології', '2025-09-10', '2025-12-25'),
('UI/UX Дизайн', '2025-10-05', '2026-01-30'),
('Основи кібербезпеки', '2025-09-20', '2026-01-10');

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date) VALUES
(1, 101, 'Анна Сидоренко', 'anna.sydorenko@example.com', '2006-05-12'),
(2, 102, 'Дмитро Кравчук', 'dmytro.kravchuk@example.com', '2005-11-03'),
(3, 103, 'Олена Ткаченко', 'olena.tkachenko@example.com', '2007-01-25'),    
(1, 101, 'Сергій Лисенко', 'serhii.lysenko@example.com', '2006-07-14'),
(4, 104, 'Олена Ткаченко', 'olena.tkachenko@example.com', '2007-01-25'),
(2, 102, 'Анна Сидоренко', 'anna.sydorenko@example.com', '2006-05-12'),
(4, 104, 'Микола Кусь', 'mykola.kus@example.com', '2000-04-12'),
(5, 104, 'Ірина Мельник', 'iryna.melnyk@example.com', '2004-03-19'),
(6, 105, 'Петро Савчук', 'petro.savchuk@example.com', '2005-08-22'),
(7, 106, 'Наталія Бойко', 'natalia.boiko@example.com', '2007-12-05'),
(8, 107, 'Артем Поліщук', 'artem.polishchuk@example.com', '2006-09-14'),
(2, 108, 'Вікторія Дорошенко', 'victoria.doroshenko@example.com', '2005-06-30');

COMMIT;*/

/*--- Перевіряємо таблиці які були створенні ---*/


/*--- 3.По кожному викладачу покажіть кількість студентів з якими він працював ---*/

/*SELECT t.teacher_name,
		COUNT(st.student_name) AS Student_Count
FROM coursesdb.students st
INNER JOIN coursesdb.teachers t
ON st.teacher_no = t.teacher_no
GROUP BY t.teacher_name;*/

/* --- 4. Спеціально зробіть 3 дубляжі в таблиці students (додайте ще 3 однакові рядки) ---*/

/*INSERT INTO coursesdb.students (teacher_no, course_no, student_name, email, birth_date)
SELECT teacher_no, course_no, student_name, email, birth_date
FROM coursesdb.students
LIMIT 3;*/

/*--- 5. Перевіряєм на дублікати ---*/
/*SELECT student_name,
		COUNT(email)
FROM coursesdb.students
GROUP BY student_name
HAVING COUNT(email) > 1;*/