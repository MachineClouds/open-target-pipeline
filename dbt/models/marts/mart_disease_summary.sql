{{ config(materialized='table') }}

SELECT d.disease_id,
       d.disease_name,
       COUNT(*) as total_targets,
       COUNT(*) FILTER (WHERE a.score >= 0.5) AS targets_above_0_5,
       COUNT(*) FILTER (WHERE a.score >=0.8) AS targets_above_0_8,
       MAX(a.score) as max_score,
       AVG(a.score) as mean_score
FROM {{ref ('fact_associations')}} a
JOIN {{ref('dim_disease')}} d USING (disease_id)
GROUP BY d.disease_id, d.disease_name
