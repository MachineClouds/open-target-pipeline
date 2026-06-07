{{ config (materialized='table') }}

SELECT t.gene_symbol,
       d.disease_name,
       a.score,
       a.evidence_count
       FROM {{ ref('fact_associations') }} a
       JOIN {{ ref('dim_target') }}  t USING (target_id)
       JOIN {{ ref('dim_disease') }} d USING (disease_id)
       WHERE a.score>=0.7 AND a.evidence_count>=10
       ORDER BY a.score DESC, a.evidence_count DESC