import duckdb
from pathlib import Path
import pandas as pd
con=duckdb.connect("data/freight.duckdb") 

sql=Path('sql/staging.sql').read_text()

con.execute(sql)# execute queries


df=con.sql("SELECT * FROM full_data ;").df()# the dataset we will work on 



