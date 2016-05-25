INSERT INTO uso_area_contrib (gid_tr, id_uso, geomproj, area)
SELECT a.gid_tr, u.id_uso, ST_Intersection(a.geomproj,u.geomproj), ST_Area(ST_Intersection(a.geomproj,u.geomproj))
FROM area_contrib_eq AS a INNER JOIN uso_desagregada AS u
ON ST_Intersects(a.geomproj,u.geomproj)
WHERE ST_Area(ST_Intersection(a.geomproj,u.geomproj)) > 0.