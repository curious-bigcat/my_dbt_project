with ranked_orders as (
  select *,
         row_number() over (partition by id order by _etl_loaded_at desc) as row_num
  from {{ ref('raw_orders') }}
)
select
  id as order_id,
  user_id as customer_id,
  order_date,
  status as order_status,
  _etl_loaded_at,
  year(order_date) as order_year,
  month(order_date) as order_month
from ranked_orders
where row_num = 1
