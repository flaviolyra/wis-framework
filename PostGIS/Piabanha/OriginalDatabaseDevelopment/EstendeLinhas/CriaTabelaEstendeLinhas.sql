CREATE TABLE estende_linhas AS
SELECT ph.gid, ph.geomproj_uni as geom_linha, ph.ponta, ph.novo_no, n.geomproj AS geom_no
FROM
(SELECT h.gid, h.geomproj_uni, p.id_2 AS novo_no, 'de' AS ponta
FROM hidrografia AS h
INNER JOIN pontas_proximas_a_juncoes AS p
ON h.no_de = p.id_1
UNION
SELECT h.gid, h.geomproj_uni, p.id_2 AS novo_no, 'para' AS ponta
FROM hidrografia AS h
INNER JOIN pontas_proximas_a_juncoes AS p
ON h.no_para = p.id_1) as ph
INNER JOIN nos AS n
ON ph.novo_no = n.id;