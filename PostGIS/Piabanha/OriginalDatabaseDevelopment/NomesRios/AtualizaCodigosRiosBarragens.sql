UPDATE barragens SET corio = c.corio
FROM nomes_correspondencia AS c
WHERE barragens.nome_rio = c.nome_rio AND c.tipo = 'barragem'