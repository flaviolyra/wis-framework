CREATE VIEW linha1_nos_terminais_proximos AS
SELECT h.gid AS id_linha1, h.geomproj_uni AS geom_linha1, h.compr AS compr_linha1, 'de' AS ponta_linha1, n.id_no1, n.geom_no1, n.id_no2, n.geom_no2
FROM hidrografia AS h
INNER JOIN nos_terminais_proximos AS n
ON h.no_de = n.id_no1
UNION
SELECT h.gid AS id_linha1, h.geomproj_uni AS geom_linha1, h.compr AS compr_linha1, 'para' AS ponta_linha1, n.id_no1, n.geom_no1, n.id_no2, n.geom_no2
FROM hidrografia AS h
INNER JOIN nos_terminais_proximos AS n
ON h.no_para = n.id_no1
