INSERT INTO nomes_correspondencia (tipo, nome_rio)
SELECT DISTINCT 'barragem', nome_rio FROM barragens