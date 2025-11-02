-- SQL Question
-- https://platform.stratascratch.com/coding/10318-new-products?code_type=3


select 
    company_name,
    sum(case 
        when year=2020 then 1
    end) - 
    sum(case 
        when year=2019 then 1
    end) as total_launch
from
    car_launches
group by
    company_name;

