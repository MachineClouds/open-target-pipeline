{{ config(materialized='table') }}

SELECT
    target_id,
    disease_id,
    score,
    evidence_count
FROM {{ ref('stg_associations') }}