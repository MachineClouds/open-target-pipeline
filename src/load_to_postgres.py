import pandas as pd
import numpy as np
from sqlalchemy import text
from src.db import engine

DATASETS = {
    "data/raw/disease/": "raw_diseases",
    "data/raw/target/": "raw_targets",
    "data/raw/association_overall_direct/": "raw_associations_direct",
}


def load_dataset(parquet_path: str, table_name: str):
    print(f"Loading {parquet_path} -> {table_name}")

    df = pd.read_parquet(parquet_path)
    print(f"  Read {len(df):,} rows, {len(df.columns)} columns")

    simple_cols = [
        c for c in df.columns
        if not df[c].apply(lambda x: isinstance(x, (list, dict, np.ndarray))).any()
    ]
    df_simple = df[simple_cols]
    print(f"  Keeping {len(simple_cols)} simple columns (dropped nested ones)")

    # Truncate the table if it already exists (preserves dbt views)
    with engine.begin() as conn:
        conn.execute(text(f"""
            DO $$
            BEGIN
                IF EXISTS (
                    SELECT FROM information_schema.tables 
                    WHERE table_schema = 'public' AND table_name = '{table_name}'
                ) THEN
                    EXECUTE 'TRUNCATE TABLE {table_name}';
                END IF;
            END $$;
        """))

    df_simple.to_sql(
        table_name,
        engine,
        if_exists="append",
        index=False,
        chunksize=10_000,
    )

    print(f"  Loaded -> {table_name}\n")


if __name__ == "__main__":
    for path, table in DATASETS.items():
        load_dataset(path, table)
    print("Done.")