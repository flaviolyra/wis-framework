UPDATE novo_desenho_trecho SET geomproj = ST_AddPoint(geomproj, ST_GeomFromText('POINT(668128 7518783)', 32723), 13)
WHERE gid = 1117
