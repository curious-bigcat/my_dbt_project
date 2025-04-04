with stats as (
  select
    avg(amount) as avg_amount,
    stddev(amount) as std_amount
  from {{ ref('stg_payments') }}
)
select
  p.*,
  s.avg_amount,
  s.std_amount,
  case
    when p.amount > s.avg_amount + 3 * s.std_amount then 'High Outlier'
    when p.amount < s.avg_amount - 3 * s.std_amount then 'Low Outlier'
    else 'Normal'
  end as anomaly_flag
from {{ ref('stg_payments') }} p
cross join stats s
