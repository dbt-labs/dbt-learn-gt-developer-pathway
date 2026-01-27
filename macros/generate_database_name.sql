{% macro generate_database_name(custom_database_name=none, node=none) -%}

    {%- set default_database = target.database -%}
    {%- set target_name = env_var("DBT_ENVIRONMENT_NAME") -%}
    
    {%- if custom_database_name is none -%}

        {{ default_database }} --_{{ target_name }} 

    {%- else -%}

        {{ custom_database_name | trim }}

    {%- endif -%}

{%- endmacro %}