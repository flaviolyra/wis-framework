UPDATE novo_desenho_trecho SET geomproj = ST_RemovePoint(geomproj, 8)
WHERE gid = 1117
