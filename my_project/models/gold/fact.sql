{% set tables = [
    {
        "table": "DEV_DB.gold.obt",
        "columns": "obt.total_amount,obt.response_rate",
        "alias": "obt"
    }
 
] %}

select

   {{tables[0]['columns']}}

from {{ tables[0].table }} as {{ tables[0].alias }}
{% for t in tables[1:] %}
    left join {{ t.table }} as {{ t.alias }}
    on {{ t.join_condition }}
{% endfor %}
