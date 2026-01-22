with 

source as (

    select * from {{ source('stripe', 'payment') }}

),

renamed as (

    select
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status,
        {{ cents_to_dollars('amount') }} as amount,
        created,
        _batched_at,
        {{ dbt_utils.generate_surrogate_key(['payment_id', 'order_id']) }} as payment_sk

    from source

)

select * from renamed