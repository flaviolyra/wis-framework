UPDATE fluviometricas SET corio = c.corio
FROM nomes_correspondencia AS c
WHERE fluviometricas.nome_rio = c.nome_rio AND c.tipo = 'fluviometrica'