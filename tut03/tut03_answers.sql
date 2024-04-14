-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

SELECT first_name, last_name FROM students;


SELECT course_name, credit_hours FROM courses;


SELECT first_name, last_name, email FROM instructors;


SELECT courses.course_name, enrollments.grade 
FROM enrollments
JOIN courses ON enrollments.course_id = courses.course_id;


SELECT first_name, last_name, city FROM students;


SELECT courses.course_name, instructors.first_name, instructors.last_name
FROM courses
JOIN instructors ON courses.instructor_id = instructors.instructor_id;



SELECT first_name, last_name, age FROM students;


SELECT courses.course_name, enrollments.enrollment_date 
FROM enrollments
JOIN courses ON enrollments.course_id = courses.course_id;



SELECT first_name, last_name, email FROM instructors;



SELECT course_name, credit_hours FROM courses;



SELECT instructors.first_name, instructors.last_name, instructors.email
FROM courses
JOIN instructors ON courses.instructor_id = instructors.instructor_id
WHERE course_name = 'Mathematics';



SELECT courses.course_name, enrollments.grade 
FROM enrollments
JOIN courses ON enrollments.course_id = courses.course_id
WHERE grade = 'A';



SELECT students.first_name, students.last_name, students.state
FROM students
JOIN enrollments ON students.student_id = enrollments.student_id
JOIN courses ON enrollments.course_id = courses.course_id
WHERE course_name = 'Computer Science';


SELECT courses.course_name, enrollments.enrollment_date 
FROM enrollments
JOIN courses ON enrollments.course_id = courses.course_id
WHERE grade = 'B+';



SELECT instructors.first_name, instructors.last_name, instructors.email
FROM courses
JOIN instructors ON courses.instructor_id = instructors.instructor_id
WHERE credit_hours > 3;
