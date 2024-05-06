Here are the relational algebra expressions for the given questions, based on the provided database schema:

1. Select all employees from the 'Engineering' department:
   \(\sigma_{department\_name = 'Engineering'}(employees \bowtie departments)\)

2. Projection to display only the first names and salaries of all employees:
   \(\pi_{first\_name, salary}(employees)\)

3. Find employees who are managers:
   \(\sigma_{employees.emp\_id = departments.manager\_id}(employees \bowtie departments)\)

4. Retrieve employees earning a salary greater than \(\$60000\):
   \(\sigma_{salary > 60000}(employees)\)

5. Join employees with their respective departments:
   \(employees \bowtie departments\)

6. Cartesian product between employees and projects:
   \(employees \times projects\)

7. Find employees who are not managers:
   \(\sigma_{employees.emp\_id \neq departments.manager\_id}(employees \bowtie departments)\)

8. Natural join between departments and projects:
   \(departments \bowtie projects\)

9. Project the department names and locations from departments table:
   \(\pi_{department\_name, location}(departments)\)

10. Retrieve projects with budgets greater than \(\$100000\):
    \(\sigma_{budget > 100000}(projects)\)

11. Find employees who are managers in the 'Sales' department:
    \(\sigma_{department\_name = 'Sales' \wedge employees.emp\_id = departments.manager\_id}(employees \bowtie departments)\)

12. Union operation between employees from the 'Engineering' and 'Finance' departments:
    \(\sigma_{department\_name = 'Engineering'}(employees) \cup \sigma_{department\_name = 'Finance'}(employees)\)

13. Find employees who are not assigned to any projects:
    \(employees - (employees \bowtie projects)\)

14. Join operation to display employees along with their project assignments:
    \(employees \bowtie projects\)

15. Find employees whose salaries are not within the range \(\$50000\) to \(\$70000\):
    \(\sigma_{salary < 50000 \vee salary > 70000}(employees)\)

These relational algebra expressions utilize selection (\(\sigma\)), projection (\(\pi\)), Cartesian product (\(\times\)), natural join (\(\bowtie\)), set difference (\(-\)), and union (\(\cup\)) operations to perform the specified tasks on the given database schema. Adjustments can be made based on specific SQL dialect and syntax requirements.
