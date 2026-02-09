{{config(materialized ='incremental',
unique_key= 'LISTING_ID')}}

select LISTING_ID,HOST_ID,
PROPERTY_TYPE, ROOM_TYPE, CITY, {{tag('PRICE_PER_NIGHT')}} as nightprice from
{{ref('bronze_listings')}}