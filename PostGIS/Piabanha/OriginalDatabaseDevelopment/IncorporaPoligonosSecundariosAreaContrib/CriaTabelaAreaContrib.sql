INSERT INTO areacontrib (id_trecho, geomproj)
SELECT id_tr AS id_trecho, (ST_Dump(geomproj_agreg)).geom AS geomproj FROM
(SELECT id_tr, ST_Union(geomproj) as geomproj_agreg FROM
(SELECT id_trecho_princ AS id_tr, geomproj FROM areacontrib_a_incorp UNION SELECT id_trecho AS id_tr, geomproj FROM areacontrib_princ) AS ai
GROUP BY id_tr) AS aa
ORDER BY id_trecho
