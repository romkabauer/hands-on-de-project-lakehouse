{{
    config(
        materialized='incremental',
        incremental_strategy='delete+insert',
        schema='stg',
        unique_key='expense_id'
    )
}}

SELECT
    MD5(CAST(TRIM(user_id) || TRIM(expense_timestamp) AS VARBINARY)) AS expense_id,
    TRIM(user_id) AS user_id,
    TRIM(user_country) AS user_country,
    TRIM(category) AS expense_category,
    CAST(amount AS DECIMAL(18,10)) AS expense_amount,
    TRIM(currency) AS expense_currency,
    TRIM(custom_message) AS expense_details,
    TRY_CAST(TRIM(expense_timestamp) AS TIMESTAMP) AS expense_ts,
    CURRENT_TIMESTAMP AS ingested_at_ts
FROM {{ source('raw', 'expenses') }} AS new
{%- if is_incremental() %}
    WHERE NOT EXISTS (
        SELECT 1 FROM {{ this }} AS cur
        WHERE MD5(CAST(TRIM(new.user_id) || TRIM(new.expense_timestamp) AS VARBINARY)) = cur.expense_id
    )
{%- endif -%}
