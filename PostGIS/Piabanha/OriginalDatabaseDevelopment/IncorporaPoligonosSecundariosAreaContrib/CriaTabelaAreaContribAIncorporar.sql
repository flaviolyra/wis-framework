CREATE TABLE areacontrib_a_incorp AS
SELECT DISTINCT ON (s.gid, s.id_trecho) s.gid, s.id_trecho, p.gid AS gid_princ, p.id_trecho AS id_trecho_princ, ST_Length(ST_Intersection(s.geomproj, p.geomproj)), s.geomproj
FROM areacontrib_sec AS s INNER JOIN areacontrib_princ AS p
ON ST_Touches(s.geomproj, p.geomproj)
WHERE ST_Length(ST_Intersection(s.geomproj, p.geomproj)) <> 0.
ORDER BY S.gid, s.id_trecho, ST_Length(ST_Intersection(s.geomproj, p.geomproj)) DESC