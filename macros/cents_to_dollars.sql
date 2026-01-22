{% macro cents_to_dollars(amount, decimals=2) %}
    round( {{ amount }} * 1.0 / 100, {{ decimals }})
{% endmacro %}