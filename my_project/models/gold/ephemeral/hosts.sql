with hosts as (

    select host_id,newname,response_rate,rating, created_at from {{ref('obt')}}
)

select * from hosts