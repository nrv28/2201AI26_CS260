-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

-- 1. Create a trigger that automatically increases the salary by 10% for employees whose salary is below ?60000 when a new record is inserted into the employees table.
DELIMITER //
CREATE TRIGGER IncreaseSalaryTrigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 60000 THEN
        SET NEW.salary = NEW.salary * 1.10;
    END IF;
END;
//
DELIMITER ;


--2. Create a trigger that prevents deleting records from the departments table if there are employees assigned to that department.
DELIMITER //
CREATE TRIGGER PreventDeleteDepartmentTrigger
BEFORE DELETE ON departments
FOR EACH ROW
BEGIN
    DECLARE employee_count INT;
    SELECT COUNT(*) INTO employee_count
    FROM employees
    WHERE department_id = OLD.department_id;
    IF employee_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete department with assigned employees';
    END IF;
END;
//
DELIMITER ;


-- 3. Write a trigger that logs the details of any salary updates (old salary, new salary, employee name, and date) into a separate audit table.
DELIMITER //
CREATE TRIGGER SalaryUpdateAuditTrigger
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salary_audit (emp_id, old_salary, new_salary, employee_name, updated_at)
    VALUES (OLD.emp_id, OLD.salary, NEW.salary, CONCAT(NEW.first_name, ' ', NEW.last_name), NOW());
END;
//
DELIMITER ;


-- 4. Create a trigger that automatically assigns a department to an employee based on their salary range (e.g., salary <= ?60000 -> department_id = 3).
DELIMITER //
CREATE TRIGGER AssignDepartmentTrigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary <= 60000 THEN
        SET NEW.department_id = 3;
    END IF;
END;
//
DELIMITER ;


-- 5. Write a trigger that updates the salary of the manager (highest-paid employee) in each department whenever a new employee is hired in that department.
DELIMITER //
CREATE TRIGGER UpdateManagerSalaryTrigger
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    UPDATE employees
    SET salary = (SELECT MAX(salary) FROM employees WHERE department_id = NEW.department_id)
    WHERE emp_id = (SELECT manager_id FROM departments WHERE department_id = NEW.department_id);
END;
//
DELIMITER ;


-- 6. Create a trigger that prevents updating the department_id of an employee if they have worked on projects.
DELIMITER //
CREATE TRIGGER PreventUpdateDepartmentTrigger
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    DECLARE project_count INT;
    SELECT COUNT(*) INTO project_count
    FROM works_on
    WHERE emp_id = NEW.emp_id;
    IF project_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update department for employee with assigned projects';
    END IF;
END;
//
DELIMITER ;


-- 7. Write a trigger that calculates and updates the average salary for each department whenever a salary change occurs.
DELIMITER //
CREATE TRIGGER UpdateAverageSalaryTrigger
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    DECLARE avg_salary DECIMAL(10, 2);
    SELECT AVG(salary) INTO avg_salary
    FROM employees
    WHERE department_id = NEW.department_id;
    UPDATE departments
    SET average_salary = avg_salary
    WHERE department_id = NEW.department_id;
END;
//
DELIMITER ;


--8. Create a trigger that automatically deletes all records from the works_on table for an employee when that employee is deleted from the employees table.
DELIMITER //
CREATE TRIGGER DeleteWorksOnTrigger
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    DELETE FROM works_on WHERE emp_id = OLD.emp_id;
END;
//
DELIMITER ;


--9. Write a trigger that prevents inserting a new employee if their salary is less than the minimum salary set for their department.
DELIMITER //
CREATE TRIGGER PreventInsertEmployeeTrigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    DECLARE min_salary DECIMAL(10, 2);
    SELECT minimum_salary INTO min_salary
    FROM departments
    WHERE department_id = NEW.department_id;
    IF NEW.salary < min_salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee salary cannot be less than department minimum';
    END IF;
END;
//
DELIMITER ;


--10. Create a trigger that automatically updates the total salary budget for a department whenever an employee's salary is updated.
DELIMITER //
CREATE TRIGGER UpdateTotalBudgetTrigger
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    DECLARE total_salary DECIMAL(10, 2);
    SELECT SUM(salary) INTO total_salary
    FROM employees
    WHERE department_id = NEW.department_id;
    UPDATE departments
    SET total_salary_budget = total_salary
    WHERE department_id = NEW.department_id;
END;
//
DELIMITER ;


-- 111. Write a trigger that sends an email notification to HR whenever a new employee is hired.
CREATE TABLE email_queue (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipient_email VARCHAR(255) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- trigger
DELIMITER //
CREATE TRIGGER NewEmployeeNotificationTrigger
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    DECLARE recipient_email VARCHAR(255);
    DECLARE subject VARCHAR(255);
    DECLARE message TEXT;

    SET recipient_email = 'hr@example.com'; -- Change this to the HR email address
    SET subject = 'New Employee Hired';
    SET message = CONCAT('A new employee has been hired. Name: ', NEW.first_name, ' ', NEW.last_name, ', ID: ', NEW.emp_id);

    INSERT INTO email_queue (recipient_email, subject, message)
    VALUES (recipient_email, subject, message);
END;
//
DELIMITER ;

-- 12. Create a trigger that prevents inserting a new department if the location is not specified.
DELIMITER //
CREATE TRIGGER PreventInsertDepartmentTrigger
BEFORE INSERT ON departments
FOR EACH ROW
BEGIN
    IF NEW.location IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Location must be specified for a new department';
    END IF;
END;
//
DELIMITER ;


-- 13. Write a trigger that updates the department_name in the employees table when the corresponding department_name is updated in the departments table.
DELIMITER //
CREATE TRIGGER UpdateEmployeeDepartmentNameTrigger
AFTER UPDATE ON departments
FOR EACH ROW
BEGIN
    UPDATE employees
    SET department_name = NEW.department_name
    WHERE department_id = NEW.department_id;
END;
//
DELIMITER ;


--14. Create a trigger that logs all insert, update, and delete operations on the employees table into a separate audit table.
CREATE TABLE employee_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    operation_type VARCHAR(10) NOT NULL,
    emp_id INT,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    salary DECIMAL(10, 2),
    department_id INT,
    operation_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER EmployeeAuditTrigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_audit (operation_type, emp_id, first_name, last_name, salary, department_id)
    VALUES ('INSERT', NEW.emp_id, NEW.first_name, NEW.last_name, NEW.salary, NEW.department_id);
END;
//

CREATE TRIGGER EmployeeAuditTriggerUpdate
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_audit (operation_type, emp_id, first_name, last_name, salary, department_id)
    VALUES ('UPDATE', OLD.emp_id, OLD.first_name, OLD.last_name, OLD.salary, OLD.department_id);
END;
//

CREATE TRIGGER EmployeeAuditTriggerDelete
BEFORE DELETE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO employee_audit (operation_type, emp_id, first_name, last_name, salary, department_id)
    VALUES ('DELETE', OLD.emp_id, OLD.first_name, OLD.last_name, OLD.salary, OLD.department_id);
END;
//

DELIMITER ;


--15. Write a trigger that automatically generates an employee ID using a sequence whenever a new employee
DELIMITER //
CREATE TRIGGER GenerateEmployeeIdTrigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    DECLARE next_id INT;
    SET next_id = (SELECT COALESCE(MAX(emp_id), 0) + 1 FROM employees);
    SET NEW.emp_id = next_id;
END;
//
DELIMITER ;

