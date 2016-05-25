UPDATE hidrografia SET geomproj_uni = lm.geomproj
FROM

-- Linha 1735 cortada estendida até o nó 609

(SELECT
ST_AddPoint(le.geomproj, ps.geomproj, -1) AS geomproj
FROM

-- Linha 1735 cortada - só com vertices 29 em diante

(SELECT ST_MakeLine(pls.geomproj) AS geomproj
FROM
(SELECT pl.geomproj
FROM pontos_linha(1735) AS pl
WHERE pl.np >28) AS pls) AS le

CROSS JOIN

-- No 609

(SELECT n.geomproj
FROM nos AS n
WHERE n.id = 609) AS ps) AS lm

WHERE hidrografia.gid = 1735;