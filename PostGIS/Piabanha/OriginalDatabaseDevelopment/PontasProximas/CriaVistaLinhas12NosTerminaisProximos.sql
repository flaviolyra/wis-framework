CREATE VIEW linhas12_nos_terminais_proximos AS
SELECT ln.id_linha1, ln.geom_linha1, ln.compr_linha1, ln.ponta_linha1,
       h.gid AS id_linha2, h.geomproj_uni AS geom_linha2, h.compr AS compr_linha2, 'de' AS ponta_linha2,
       ln.id_no1, ln.geom_no1, ln.id_no2, ln.geom_no2
FROM hidrografia AS h
INNER JOIN linha1_nos_terminais_proximos AS ln
ON h.no_de = ln.id_no2
UNION
SELECT ln.id_linha1, ln.geom_linha1, ln.compr_linha1, ln.ponta_linha1,
       h.gid AS id_linha2,  h.geomproj_uni AS geom_linha2,h.compr AS compr_linha2, 'para' AS ponta_linha2,
       ln.id_no1, ln.geom_no1, ln.id_no2, ln.geom_no2
FROM hidrografia AS h
INNER JOIN linha1_nos_terminais_proximos AS ln
ON h.no_para = ln.id_no2
