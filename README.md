# Open Targets Drug Discovery Pipeline

A cloud-native data warehouse and target prioritisation pipeline built on the [Open Targets Platform](https://platform.opentargets.org/) — the same drug discovery dataset used by GSK, Pfizer, Sanofi, and other major pharmaceutical companies for target identification.

**Status:** Active build, Week 1 of 6. Currently exploring raw data. See [Roadmap](#roadmap) below.

## Why This Project

Before a pharmaceutical company spends $1B+ developing a drug, they need to answer one question: which gene should we target? This is called **target identification**, and getting it wrong is the leading cause of clinical trial failure.

Open Targets is a public dataset that helps answer that question by integrating evidence from human genetics, clinical trials, animal models, and biomedical literature into scored target–disease associations. Drug targets with strong genetic evidence are roughly twice as likely to make it through clinical trials.

This project builds production-grade data infrastructure around that dataset:

- A cloud-hosted, dimensionally-modelled data warehouse
- An orchestrated, incremental refresh pipeline
- A target prioritisation scoring layer
- An interactive dashboard for exploring drug-disease relationships

## Architecture (Target)

```
                    +--------------------+
                    |  Open Targets FTP  |
                    |  (Parquet, 25.03)  |
                    +---------+----------+
                              | Airflow DAG
                              v
                    +--------------------+
                    |      AWS S3        |
                    |   (Raw landing)    |
                    +---------+----------+
                              | dbt
                              v
                    +--------------------+
                    |  PostgreSQL / RDS  |
                    |   (Star schema)    |
                    +---------+----------+
                              |
                  +-----------+------------+
                  v                        v
        +------------------+     +------------------+
        | Scoring Layer    |     |  Streamlit App   |
        | (Python)         |     |  (Query + Rank)  |
        +------------------+     +------------------+
```

## Data Model

The warehouse is structured as a star schema around target–disease associations.

The disease dimension preserves the EFO / MONDO ontology hierarchy as an array of ancestor IDs, enabling hierarchical rollup queries (e.g. "all neurodegenerative diseases" rather than listing every subtype individually).

## Tech Stack

| Layer | Technology |
| --- | --- |
| Source data | Open Targets Platform (Parquet, release 25.03) |
| Ingestion / staging | Python, AWS S3 |
| Transformation | dbt |
| Warehouse | PostgreSQL / AWS RDS |
| Orchestration | Apache Airflow (MWAA) |
| Scoring | Python |
| Dashboard | Streamlit |

## Repository Structure

```
open-targets-pipeline/
├── data/raw/                 # Parquet files from Open Targets (gitignored)
├── notebooks/                # Exploratory Jupyter notebooks
│   └── 01_data_exploration.ipynb
├── src/                      # Ingestion and processing scripts
├── dbt/                      # dbt project (coming Week 3)
├── airflow/                  # Airflow DAGs (coming Week 4)
├── streamlit/                # Dashboard app (coming Week 5)
└── README.md
```

## Roadmap

- [x] **Week 1 — Data exploration:** download Open Targets 25.03, explore schema, run first cross-table join
- [ ] **Week 2 — Local Postgres warehouse:** load raw Parquet into PostgreSQL via Docker
- [ ] **Week 3 — dbt modelling:** build star schema with tests, implement hierarchical ontology rollup
- [ ] **Week 4 — Airflow orchestration:** incremental loads handling Open Targets release cycle
- [ ] **Week 5 — Scoring layer + Streamlit dashboard**
- [ ] **Week 6 — Cloud deployment:** S3, RDS, MWAA; finalise docs and blog posts

## Early Results

Joining the three core tables and filtering to Alzheimer's disease (`MONDO_0004975`) produces a ranked list of the top genetic drug targets — including several that are already targeted by approved Alzheimer's drugs (ACHE, BCHE, APP) and emerging therapeutics (APH1B, SORL1).

This validates the pipeline conceptually before infrastructure work begins.

## Author

**Shikhar Ghimire** — Data / ML Engineer
