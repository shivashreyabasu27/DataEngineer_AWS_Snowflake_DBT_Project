{{config(materialized='incremental', unique_key= 'HOST_ID')}}

select HOST_ID, REPLACE(host_name,'','__') as newname ,response_rate,
case when response_rate > 95 then 'good'
else'avg'
end as rating
from {{ref('bronze_hosts')}}