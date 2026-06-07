{{ config(materialized='table') }}

SELECT
    disease_id,
    disease_name,
    disease_description,
    ontology_url
FROM {{ ref('stg_diseases') }}