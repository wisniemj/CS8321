import pymysql
import pandas as pd
import numpy as np

db_params = {
    'host': 'localhost',
    'port': 3306,
    'user': 'wisniemj',
    'password': 'abc123$MW',
    'database': 'chembl'
}

conn = pymysql.connect(**db_params)

sql = """
SELECT  a.standard_value,
        b.le,
        d.target_type,
        d.pref_name,
        e.canonical_smiles,
        f.molecular_species
FROM chembl.activities a

inner join chembl.ligand_eff b
on a.activity_id = b.activity_id

inner join chembl.assays c
on a.assay_id = c.assay_id

inner join chembl.target_dictionary d
on d.tid = c.tid

inner join chembl.compound_structures e
on a.molregno = e.molregno

inner join chembl.compound_properties f
on a.molregno = f.molregno

where a.standard_type = 'IC50' and a.standard_units = 'nM' and (a.standard_value <= 300 or a.standard_value >= 10000);
"""

df = pd.read_sql_query(sql, conn)

df = df.replace("\\N", pd.NA, regex=False)
df.to_csv("chemBL.csv", index=False)
