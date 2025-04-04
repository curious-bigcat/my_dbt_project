with first_order as (
  select
    customer_id,
    min(order_date) as first_order_date
  from {{ ref('stg_orders') }}
  group by 1
),
tagged_orders as (
  select
    o.*,
    case when o.order_date = f.first_order_date then 'First Order' else 'Repeat' end as order_type
  from {{ ref('stg_orders') }} o
  join first_order f on o.customer_id = f.customer_id
)
select
  order_type,
  count(*) as order_count,
  sum(p.amount) as total_revenue
from tagged_orders o
left join {{ ref('stg_payments') }} p on o.order_id = p.order_id
group by 1
