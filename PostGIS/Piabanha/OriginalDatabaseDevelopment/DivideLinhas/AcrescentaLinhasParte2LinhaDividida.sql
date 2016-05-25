INSERT INTO hidrografia (nome_dre, compr, geomproj_uni)
SELECT nome_dre,
       ST_Length2d(ST_SetPoint(l.geom_parte2,0,l.geom_int)) AS compr,
       ST_SetPoint(l.geom_parte2,0,l.geom_int) AS geomproj_uni
FROM linhas_a_dividir AS l;