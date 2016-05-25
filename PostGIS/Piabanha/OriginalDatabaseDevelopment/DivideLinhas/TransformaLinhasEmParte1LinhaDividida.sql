UPDATE hidrografia SET geomproj_uni = ST_SetPoint(l.geom_parte1,ST_NumPoints(l.geom_parte1)-1,l.geom_int)
FROM linhas_a_dividir AS l
WHERE hidrografia.gid = l.gid;