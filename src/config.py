"""
Central place for all project paths.

Every script and notebook should import paths from here 
,so the code works no matter which folder it is run from.
"""
from pathlib import Path

#src/, parents[1] = project root
PROJECT_ROOT = Path(__file__).resolve().parents[1]

DATA_DIR = PROJECT_ROOT / "data"
RAW_DIR = DATA_DIR / "raw"              # original Olist CSVs 
PROCESSED_DIR = DATA_DIR / "processed"  # ML-ready datasets

SQL_DIR = PROJECT_ROOT / "sql"
NOTEBOOKS_DIR = PROJECT_ROOT / "notebooks"

DB_PATH = DATA_DIR / "freight.duckdb"
STAGING_SQL = SQL_DIR / "staging.sql"
FULL_DATA_PARQUET = PROCESSED_DIR / "full_data.parquet"

