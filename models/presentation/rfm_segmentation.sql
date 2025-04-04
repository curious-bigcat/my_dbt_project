with customer_metrics as (
  select
    c.customer_id,
    max(p.payment_date) as last_payment_date,
    count(distinct o.order_id) as frequency,
    sum(p.amount) as monetary
  from {{ ref('stg_customers') }} c
  left join {{ ref('stg_orders') }} o on c.customer_id = o.customer_id
  left join {{ ref('stg_payments') }} p on o.order_id = p.order_id
  group by 1
)
select *,
  datediff('day', last_payment_date, current_date) as recency,
  case
    when recency < 30 and frequency >= 5 and monetary > 500 then 'Champion'
    when recency < 60 and frequency >= 3 then 'Loyal'
    when recency < 90 then 'Recent'
    else 'At Risk'
  end as rfm_segment
from customer_metrics
