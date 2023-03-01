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
        d.*,
        e.canonical_smiles
-- output data
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/result.tsv'
FIELDS TERMINATED BY '\t' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM chembl.activities a

-- Join on ligand table
inner join chembl.ligand_eff b
on a.activity_id = b.activity_id

-- Join on Target Components
inner join chembl.target_components c
on a.tid = c.tid

-- Join on Assays
inner join chembl.assays d
on a.assay_id = d.assay_id

-- Join on Compound Properties for the Smiles
inner join chembl.compound_structures e
on a.molregno = e.molregno

where a.standard_type = 'IC50' and a.standard_units = 'nM' and (a.standard_value <= 300 or a.standard_value >= 10000);

SHOW VARIABLES LIKE "secure_file_priv";

select distinct(component_type) from chembl.component_sequences;

select * from chembl.target_dictionary;

SELECT 
    tc.tid AS target_id, 
    tc.pref_name AS target_name, 
    COUNT(*) AS assay_count
FROM 
    chembl.assays a 
    JOIN chembl.target_dictionary tc ON a.tid = tc.tid
GROUP BY 
    tc.tid, 
    tc.pref_name
ORDER BY 
    assay_count DESC;
