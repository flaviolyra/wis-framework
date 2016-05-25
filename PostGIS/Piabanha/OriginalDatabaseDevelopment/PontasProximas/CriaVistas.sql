-- Cria Vista nos_terminais_proximos

CREATE OR REPLACE VIEW nos_terminais_proximos AS 
 SELECT n1.id AS id_no1, n1.geomproj AS geom_no1, n2.id AS id_no2, n2.geomproj AS geom_no2
   FROM nos n1
   JOIN nos n2 ON st_dwithin(n1.geomproj, n2.geomproj, 10::numeric::double precision) AND n1.id <> n2.id AND n1.num_conex = 1 AND n2.num_conex = 1;

-- Cria Vista linha1_nos_terminais_proximos

CREATE VIEW linha1_nos_terminais_proximos AS
SELECT h.gid AS id_linha1, h.geomproj_uni AS geom_linha1, h.compr AS compr_linha1, 'de' AS ponta_linha1, n.id_no1, n.geom_no1, n.id_no2, n.geom_no2
FROM hidrografia AS h
INNER JOIN nos_terminais_proximos AS n
ON h.no_de = n.id_no1
UNION
SELECT h.gid AS id_linha1, h.geomproj_uni AS geom_linha1, h.compr AS compr_linha1, 'para' AS ponta_linha1, n.id_no1, n.geom_no1, n.id_no2, n.geom_no2
FROM hidrografia AS h
INNER JOIN nos_terminais_proximos AS n
ON h.no_para = n.id_no1;

-- Cria Vista linhas12_nos_terminais_proximos

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
ON h.no_para = ln.id_no2;
