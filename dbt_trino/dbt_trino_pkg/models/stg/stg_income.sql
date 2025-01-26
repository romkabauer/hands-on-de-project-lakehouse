SELECT
    TRIM(user_id) AS user_id,
    TRIM(user_country) AS user_country,
    TRIM(source) AS income_source_name,
    CAST(TRIM(amount) AS DECIMAL(18,10)) AS income_amount,
    TRIM(currency) AS income_currency,
    CURRENT_DATE AS income_dt,
    CURRENT_TIMESTAMP AS ingested_at_ts
FROM {{ source('raw', 'income_batch') }}
WHERE LOWER(user_id) <> 'user_id'
