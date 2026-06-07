{{ config (materialized = 'table')}}

SELECT 
    target_id,
    gene_symbol,
    gene_name,
    biotype
FROM {{ ref('stg_targets') }}