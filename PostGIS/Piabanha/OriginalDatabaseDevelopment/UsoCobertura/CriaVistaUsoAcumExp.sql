CREATE VIEW uso_acum_exp AS 
 SELECT ua.gid_tr, ua.id_uso, u.uso, ua.area / 1000000. AS area_km2
 FROM uso_acum AS ua INNER JOIN usos AS u ON ua.id_uso = u.id_uso
 ORDER BY ua.gid_tr, ua.id_uso