UPDATE ptreservatorios SET corio = c.corio
FROM nomes_correspondencia AS c
WHERE ptreservatorios.nome_rio = c.nome_rio AND c.tipo = 'reservatorio'