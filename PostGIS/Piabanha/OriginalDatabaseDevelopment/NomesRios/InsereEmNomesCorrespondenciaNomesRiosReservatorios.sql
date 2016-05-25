INSERT INTO nomes_correspondencia (tipo, nome_rio)
SELECT DISTINCT 'reservatorio', nome_rio FROM ptreservatorios