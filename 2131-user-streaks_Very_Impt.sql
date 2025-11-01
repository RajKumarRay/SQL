-- SQL Question
-- https://platform.stratascratch.com/coding/2131-user-streaks?code_type=3


with unique_data_cte as (
    select 
        distinct 
            user_id,
            date_visited
    from 
        user_streaks 
    where 
        date_visited<='2022-08-10'
    order by 
        user_id,
        date_visited
),
transformation_user_data_cte as (
    select 
        user_id,
        date_visited,
        max(date_visited) over(partition by user_id) as max_date,
        row_number() over(partition by user_id order by date_visited) as rown,
        count(date_visited) over(partition by user_id) as total_count
    from 
        unique_data_cte
),
final_transformation_cte as (
    select
        user_id,
        case
            when max_date-date_visited=total_count-rown then total_count-rown+1 else 0
        end as streak_length
    from 
        transformation_user_data_cte
),
group_cte as (
    select 
        user_id,
        max(streak_length) as streak_length 
    from 
        final_transformation_cte
    group by 
        user_id
    order by
        max(streak_length)
    desc
),
result_cte as (
    select 
        user_id,
        streak_length,
        dense_rank() over(order by streak_length desc) as dense_rnk
    from 
        group_cte
)

select 
    user_id,
    streak_length
from 
    result_cte
where
    dense_rnk<=3;
