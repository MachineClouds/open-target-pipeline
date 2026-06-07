{{ config(materialized='table') }}

SELECT
    t.target_id,
    t.gene_symbol,
    t.gene_name,
    d.disease_id,
    d.disease_name,
    a.score,
    a.evidence_count,
    ROW_NUMBER() OVER (
        PARTITION BY t.target_id
        ORDER BY a.score DESC
    ) AS rank
FROM {{ ref('fact_associations') }} a
JOIN {{ ref('dim_target') }}  t USING (target_id)
JOIN {{ ref('dim_disease') }} d USING (disease_id)