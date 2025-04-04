select 
  id as customer_id,
  initcap(first_name) as first_name,
  initcap(last_name) as last_name
from {{ ref('raw_customers') }}