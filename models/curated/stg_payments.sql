with deduped as (
  select *,
         row_number() over (partition by id order by _batched_at desc) as row_num
  from {{ ref('raw_payments') }}
)
select
  id as payment_id,
  orderid as order_id,
  paymentmethod,
  status as payment_status,
  amount,
  created as payment_date,
  _batched_at,
  year(created) as payment_year,
  month(created) as payment_month
from deduped
where row_num = 1
