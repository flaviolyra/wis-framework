INSERT INTO set_cens_area_contrib (gid_tr, gid_set_desag, gid_set_agr, geomproj, area)
SELECT a.gid_tr, s.gid, s.gid_agr, ST_Intersection(a.geomproj,s.geomproj_uni), ST_Area(ST_Intersection(a.geomproj,s.geomproj_uni))
FROM area_contrib_eq AS a INNER JOIN set_cens_rj_desagr AS s
ON ST_Intersects(a.geomproj,s.geomproj_uni)
WHERE ST_Area(ST_Intersection(a.geomproj,s.geomproj_uni)) > 0.