{% macro set_query_tag() -%}
  {# `model` is undefined outside a node (on-run-start, run-operation), so guard it #}
  {% set new_query_tag = model.name if model is defined and model.name is defined else none %}

  {% if new_query_tag %}
    {% set original_query_tag = get_current_query_tag() %}
    {{ log("Setting query_tag to '" ~ new_query_tag ~ "'. Will reset to '" ~ original_query_tag ~ "' after materialization.") }}
    {% do run_query("alter session set query_tag = '" ~ (new_query_tag | replace("'", "''")) ~ "'") %}
    {{ return(original_query_tag) }}
  {% endif %}

  {{ return(none) }}
{% endmacro %}