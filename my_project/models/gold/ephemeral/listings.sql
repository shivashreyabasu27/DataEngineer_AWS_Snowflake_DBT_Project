with listings as (

    select distinct listing_id,ROOM_TYPE, CITY, PROPERTY_TYPE
    
    from {{ref('obt')}}
)

select * from listings