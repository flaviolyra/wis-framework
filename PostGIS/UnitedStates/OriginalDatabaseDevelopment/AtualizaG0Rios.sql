UPDATE rios SET gid0 = g0.gid0
FROM
(SELECT DISTINCT ON (cocursodag) cocursodag, gid AS gid0 FROM rios ORDER BY cocursodag, gid) AS g0
WHERE rios.cocursodag = g0.cocursodag