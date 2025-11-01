-- SQL Question
-- https://platform.stratascratch.com/coding/10172-best-selling-item?code_type=3


with cte1 as (
    select 
        month(invoicedate) as months,
        description,
        sum(unitprice*quantity) as total_paid
    from 
        online_retail
    group by 
        1,2),

final_tb as (
    select 
        *,
        rank() over(partition by months order by total_paid desc) as rn
    from
        cte1
)

select months,description,total_paid from final_tb where rn=1;