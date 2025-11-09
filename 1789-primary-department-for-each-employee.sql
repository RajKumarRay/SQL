-- https://leetcode.com/problems/primary-department-for-each-employee/?envType=study-plan-v2&envId=top-sql-50


with cte1 as 
( select employee_id,count(*) as total_cnt from employee group by employee_id )

select distinct emp.employee_id,emp.department_id from employee as emp join cte1 on emp.employee_id=cte1.employee_id
where (cte1.total_cnt!=1 and emp.primary_flag='Y') or (cte1.total_cnt=1 and emp.primary_flag='N')
