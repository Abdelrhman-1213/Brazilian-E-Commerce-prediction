import duckdb

from src.config import DB_PATH, FULL_DATA_PARQUET, PROCESSED_DIR, PROJECT_ROOT, STAGING_SQL

con = duckdb.connect(str(DB_PATH))

# resolve relative paths inside staging.sql  from the project root,

con.execute(f"SET file_search_path = '{PROJECT_ROOT}'")

sql = STAGING_SQL.read_text()

con.execute(sql)  # execute queries


df = con.sql("SELECT * FROM full_data ;").df()  # the dataset we will work on

# saving the dataframe locally
PROCESSED_DIR.mkdir(parents=True, exist_ok=True)

# saved it as parquet to : keeps dtypes, small and fast
df.to_parquet(FULL_DATA_PARQUET, index=False)
