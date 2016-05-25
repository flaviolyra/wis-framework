INSERT INTO trecho_area
SELECT h.gid, a.gid, ST_Intersection(h.geomproj_uni,a.geomproj_uni), ST_Length(ST_Intersection(h.geomproj_uni,a.geomproj_uni)),
  ST_Length(ST_Intersection(h.geomproj_uni,a.geomproj_uni)) / ST_Length(h.geomproj_uni)
FROM hidrografia AS h INNER JOIN areacontrib_9 AS a ON ST_Intersects(h.geomproj_uni,a.geomproj_uni)