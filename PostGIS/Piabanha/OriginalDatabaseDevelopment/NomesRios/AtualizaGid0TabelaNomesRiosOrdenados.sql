UPDATE nomes_rios_ordenados SET gid0 = g0.gid
FROM (SELECT DISTINCT ON (cocursodag) gid, cocursodag FROM nomes_rios_ordenados ORDER BY cocursodag, gid) as g0
WHERE nomes_rios_ordenados.cocursodag = g0.cocursodag