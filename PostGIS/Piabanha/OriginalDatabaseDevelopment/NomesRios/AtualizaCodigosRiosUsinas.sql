UPDATE usinas SET corio = c.corio
FROM nomes_correspondencia AS c
WHERE usinas.nome_rio = c.nome_rio AND c.tipo = 'usina'