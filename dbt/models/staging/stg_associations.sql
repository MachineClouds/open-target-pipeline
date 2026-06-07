{{config(materialized = 'view')}}

SELECT
    "targetId" AS target_id,
    "diseaseId" AS disease_id,
    score,
    "evidenceCount" AS evidence_count
FROM {{ source ('raw', 'raw_associations_direct')}}
WHERE "targetId" IS NOT NULL
  AND "diseaseId" IS NOT NULL
  AND score IS NOT NULL