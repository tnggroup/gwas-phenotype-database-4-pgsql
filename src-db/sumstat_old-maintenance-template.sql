--UPDATE sumstat_old."GWAS" SET phenotype_id=127 WHERE id=670
UPDATE sumstat_old."GWAS" SET phenotype_id=127, reference_id=reference.id FROM sumstat_old.reference WHERE "GWAS".id=670 AND reference.pmid='31070104'

--SELECT * FROM sumstat_old.reference WHERE pmid='31070104'