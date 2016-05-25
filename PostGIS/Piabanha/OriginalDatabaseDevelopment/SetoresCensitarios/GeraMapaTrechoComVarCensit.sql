INSERT INTO mapa_trecho
SELECT sa.gid_tr, vc.id_var, vc.valor * sa.parte
FROM set_cens_area_contrib AS sa INNER JOIN var_censit_piabanha AS vc
ON sa.gid_set_agr = vc.gid_set_agr