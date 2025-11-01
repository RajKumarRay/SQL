-- SQL Question 
-- https://platform.stratascratch.com/coding/9915-highest-cost-orders?code_type=3

with final_tb as (
    select 
        c.first_name as first_name,
        o.order_date as order_date,
        sum(o.total_order_cost) as total_order_cost
    from 
        customers c 
    inner join 
        orders o
    on 
        c.id=o.cust_id
    where 
        o.order_date>='2019-02-01' and o.order_date<='2019-05-01'
    group by 
        c.first_name,o.order_date
),
final_rank_tb as (
    select 
        *,
        rank() over(partition by order_date order by total_order_cost desc ) as rn
    from final_tb
)

select
    first_name,
    order_date,
    total_order_cost
from 
    final_rank_tb
where 
    rn=1
order by 
    order_date,first_name;