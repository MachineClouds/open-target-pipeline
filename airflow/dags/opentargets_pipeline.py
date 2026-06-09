"""
Open Targets data pipeline DAG.
"""

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    "owner": "shikhar",
    "depends_on_past": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}

env = {
    "POSTGRES_HOST": "opentargets_postgres",
    "DBT_PROFILES_DIR": "/opt/airflow/dbt",
}

with DAG(
    dag_id="opentargets_pipeline",
    description="Weekly Open Targets data pipeline",
    default_args=default_args,
    start_date=datetime(2026, 1, 1),
    schedule_interval="0 2 * * 0",
    catchup=False,
    tags=["opentargets", "weekly"],
) as dag:

    load_to_postgres = BashOperator(
        task_id="load_to_postgres",
        bash_command="cd /opt/airflow && python -m src.load_to_postgres",
        env=env,
        append_env=True,
    )

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command="cd /opt/airflow/dbt && dbt run",
        env=env,
        append_env=True,
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="cd /opt/airflow/dbt && dbt test",
        env=env,
        append_env=True,
    )

    load_to_postgres >> dbt_run >> dbt_test