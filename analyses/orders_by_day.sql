with orders as(
    select *
    from {{ ref('fct_orders') }}
)
, rolled_orders as 
(
    select order_date
        , sum(amount) as total_amount
    from orders
    group by 1
)
, yesterdays_amount as 
(
    select ro.*, dateadd('day', -1, ro.order_date) as yesterdays_date, coalesce(ro2.total_amount,0) as yesterdays_amount
    from rolled_orders ro
    left join rolled_orders ro2 on dateadd('day', -1, ro.order_date) =  ro2.order_date
)
select *
from yesterdays_amount
order by order_date desc