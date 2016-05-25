CREATE VIEW linhas_pontos_terminais AS
SELECT h.gid, h.no_de, h.no_para, h.geomproj_uni AS geom_ln, ns.geomproj AS geom_pt, 'de' AS no_term FROM hidrografia AS h INNER JOIN
(SELECT id, geomproj FROM nos WHERE num_conex = 1) AS ns
ON ns.id = h.no_de
UNION
SELECT h.gid, h.no_de, h.no_para, h.geomproj_uni AS geom_ln, ns.geomproj AS geom_pt, 'para' AS no_term FROM hidrografia AS h INNER JOIN
(SELECT id, geomproj FROM nos WHERE num_conex = 1) AS ns
ON ns.id = h.no_para