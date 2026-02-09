{{ config(
    materialized='incremental',
    unique_key='BOOKING_ID'
) }}

select
    BOOKING_ID,
    LISTING_ID,
    BOOKING_DATE,
    {{multiply ('NIGHTS_BOOKED' , 'BOOKING_AMOUNT')}} as TOTAL_AMOUNT, 
    BOOKING_STATUS,
    CREATED_AT
from {{ ref('bronze_bookings') }} where LISTING_ID= 44
