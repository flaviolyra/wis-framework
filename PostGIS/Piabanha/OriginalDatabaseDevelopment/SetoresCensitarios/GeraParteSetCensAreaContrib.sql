UPDATE set_cens_area_contrib SET parte = area / ST_Area(s.geomproj_uni)
FROM set_cens_rj_desagr AS s WHERE s.gid_agr = set_cens_area_contrib.gid_set_agr