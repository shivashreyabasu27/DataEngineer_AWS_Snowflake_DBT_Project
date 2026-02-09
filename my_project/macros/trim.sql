{% macro tag(col) %}
    case
        when {{ col }} < 100 then 'low'
        else 'high'
    end
{% endmacro %}
