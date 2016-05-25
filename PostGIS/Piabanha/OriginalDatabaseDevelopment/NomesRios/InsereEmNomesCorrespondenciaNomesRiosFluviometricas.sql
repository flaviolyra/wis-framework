INSERT INTO nomes_correspondencia (tipo, nome_rio)
SELECT DISTINCT 'fluviometrica', nome_rio FROM fluviometricas