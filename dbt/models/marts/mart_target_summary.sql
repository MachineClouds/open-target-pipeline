{{ config(materialized = 'table') }}

WITH base AS (

    SELECT
        t.target_id,
        t.gene_symbol,
        t.gene_name,

        COUNT(*) AS total_diseases,

        COUNT(*) FILTER (WHERE a.score > 0.5) AS diseases_above_0_5,

        COUNT(*) FILTER (WHERE a.score > 0.8) AS diseases_above_0_8,

        MAX(a.score) AS max_score,

        AVG(a.score) AS avg_score

    FROM {{ ref('fact_associations') }} a
    JOIN {{ ref('dim_target') }} t
        USING (target_id)

    GROUP BY
        t.target_id,
        t.gene_symbol,
        t.gene_name

)

SELECT
    *,
    CASE
        WHEN diseases_above_0_5 >= 50 THEN 'broad'
        WHEN diseases_above_0_5 >= 10 THEN 'moderate'
        ELSE 'specific'
    END AS breadth_category

FROM base