{{ config(materialized='table') }}

WITH strong_pairs AS (
    SELECT
        target_id,
        disease_id,
        score
    FROM {{ ref('fact_associations') }}
    WHERE score >= 0.5
)

SELECT
    t.target_id,
    t.gene_symbol,
    t.gene_name,
    COUNT(DISTINCT s.disease_id) AS disease_count_high_evidence,
    STRING_AGG(DISTINCT d.disease_name, '; ' ORDER BY d.disease_name) AS associated_diseases,
    MAX(s.score) AS max_score,
    AVG(s.score) AS mean_score
FROM strong_pairs s
JOIN {{ ref('dim_target') }}  t USING (target_id)
JOIN {{ ref('dim_disease') }} d USING (disease_id)
GROUP BY t.target_id, t.gene_symbol, t.gene_name
HAVING COUNT(DISTINCT s.disease_id) >= 3
ORDER BY disease_count_high_evidence DESC, max_score DESC