with orders as  (
    select * from raw.jaffle_shop.orders
),

payments as (
    select * from raw.stripe.payment
),

order_payments as (
    select
        orderid,
        sum(case when status = 'success' then amount end) as amount

    from payments
    group by 1
),

final as (

    select
        orders.id as order_id,
        orders.user_id as customer_id,
        orders.order_date,
        orders.status,
        coalesce(order_payments.amount, 0) as amount

    from orders
    left join order_payments on (orders.id) = (order_payments.orderid)
)

select * from final
