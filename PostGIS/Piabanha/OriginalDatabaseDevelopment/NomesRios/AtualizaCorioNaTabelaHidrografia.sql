UPDATE hidrografia SET corio = nr.corio
FROM (SELECT n.gid, r.corio FROM nomes_cursos_rios AS n INNER JOIN nomes_rios_ordenados AS r ON n.gid_rio = r.gid_rio) AS nr
WHERE hidrografia.gid = nr.gid