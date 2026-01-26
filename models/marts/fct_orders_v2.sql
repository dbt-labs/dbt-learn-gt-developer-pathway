{{
    config(
        materialized=env_var("DBT_MATERIALIZATION"),
        pre_hook='grant select on {{ target.schema }}.fct_orders to role transformer;'
    )
}}
with orders as  
(
    select * 
    from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select * from {{ ref('stg_stripe__payment') }}
),

order_payments as (
    select
        order_id,
        sum(case when status = 'success' then amount end) as amount

    from payments
    group by 1
),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status,
        coalesce(order_payments.amount, 0) as amount,
        case when orders.status IN ('returned', 'return_pending') then true else false end as return_flag

    from orders
    left join order_payments on (orders.order_id) = (order_payments.order_id)
)

select * from final
