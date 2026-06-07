{{config(materialized = 'view')}}

SELECT 
    id as disease_id,
    name AS disease_name,
    description AS disease_description,
    code AS ontology_url
FROM {{source('raw', 'raw_diseases')}}
WHERE id IS NOT NULL

