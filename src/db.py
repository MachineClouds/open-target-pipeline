"""Database connection module for the Open Targets pipeline."""

from sqlalchemy import create_engine, text

DB_USER = "shikhar"
DB_PASSWORD = "opentargets"
DB_HOST = "127.0.0.1"
DB_PORT = "5432"
DB_NAME = "opentargets"

DATABASE_URL = f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

engine = create_engine(DATABASE_URL)


if __name__ == "__main__":
    with engine.connect() as conn:
        result = conn.execute(text("SELECT version();"))
        print("Connected to:", result.scalar())
