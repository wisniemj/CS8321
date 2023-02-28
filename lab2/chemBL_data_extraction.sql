SELECT  a.activity_id,
		a.assay_id,
        a.doc_id,
        a.record_id,
        a.molregno,
        a.standard_relation,
        a.standard_value,
        a.standard_units,
        a.standard_flag,
        a.standard_type,
        a.pchembl_value,
        b.*,
        c.*,
        d.*
-- output data
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/result.tsv'
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM chembl.activities a

-- Join on ligand table
inner join chembl.ligand_eff b
on a.activity_id = b.activity_id

-- Join on Compound Properties
inner join chembl.compound_properties c
on a.molregno = c.molregno

-- Join on Assays
inner join chembl.assays d
on a.assay_id = d.assay_id

where a.standard_type = 'IC50' and a.standard_units = 'nM';

SHOW VARIABLES LIKE "secure_file_priv";
