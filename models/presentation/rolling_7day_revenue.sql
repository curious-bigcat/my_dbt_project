select
  payment_date,
  sum(amount) as daily_revenue,
  sum(sum(amount)) over (
    order by payment_date
    rows between 6 preceding and current row
  ) as rolling_7day_revenue
from {{ ref('stg_payments') }}
group by 1
order by 1
