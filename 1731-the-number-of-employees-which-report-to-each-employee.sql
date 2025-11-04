-- https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/description/?envType=study-plan-v2&envId=top-sql-50

-- # Write your MySQL query statement below
select emp1.employee_id,emp1.name,count(*) as reports_count,
round(avg(emp2.age)) as average_age from employees emp1 join employees emp2
on emp1.employee_id=emp2.reports_to group by emp1.employee_id,emp1.name order by emp1.employee_id;