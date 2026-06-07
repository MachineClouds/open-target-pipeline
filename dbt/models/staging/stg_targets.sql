{{ config(materialized='view') }}

SELECT
    id              AS target_id,
    "approvedSymbol" AS gene_symbol,
    "approvedName"   AS gene_name,
    biotype
FROM {{ source('raw', 'raw_targets') }}
WHERE id IS NOT NULL
