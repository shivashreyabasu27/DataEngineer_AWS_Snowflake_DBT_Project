{% set tables = [
    {
        "table": "DEV_DB.SILVER.SILVER_BOOKINGS",
        "columns": "SILVER_bookings.*",
        "alias": "SILVER_bookings"
    },
    {
        "table": "DEV_DB.SILVER.SILVER_LISTINGS",
        "columns": "SILVER_listings.PROPERTY_TYPE,SILVER_LISTINGS.ROOM_TYPE,SILVER_LISTINGS.CITY,SILVER_LISTINGS.NIGHTPRICE",
        "alias": "SILVER_listings",
        "join_condition": "SILVER_bookings.listing_id = SILVER_listings.listing_id"
    },
    {
        "table": "DEV_DB.SILVER.SILVER_HOSTS",
        "columns": "SILVER_HOSTS.HOST_ID, SILVER_HOSTS.NEWNAME, SILVER_HOSTS.RESPONSE_RATE, SILVER_HOSTS.RATING",
        "alias": "SILVER_hosts",
        "join_condition": "SILVER_listings.host_id = SILVER_hosts.host_id"
    }
] %}

select
{% for t in tables %}
    {{ t.columns }}{% if not loop.last %},{% endif %}
{% endfor %}
from {{ tables[0].table }} as {{ tables[0].alias }}
{% for t in tables[1:] %}
    left join {{ t.table }} as {{ t.alias }}
    on {{ t.join_condition }}
{% endfor %}
