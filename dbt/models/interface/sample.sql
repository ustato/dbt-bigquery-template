
-- Use the `ref` function to select from other models

select num
from {{source('raw', 'table_b')}}
