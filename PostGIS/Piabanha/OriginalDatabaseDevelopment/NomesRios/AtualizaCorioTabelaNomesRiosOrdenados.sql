UPDATE nomes_rios_ordenados SET corio = cr.corio
FROM (SELECT gid, cocursodag, cocursodag || '_' || (gid - gid0)::text AS corio FROM nomes_rios_ordenados ORDER BY gid) AS cr
WHERE nomes_rios_ordenados.gid = cr.gid