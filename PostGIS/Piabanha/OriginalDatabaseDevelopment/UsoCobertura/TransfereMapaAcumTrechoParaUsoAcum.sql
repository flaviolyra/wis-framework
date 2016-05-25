INSERT INTO uso_acum (gid_tr, id_uso, area)
SELECT gid_tr, car, valacum FROM mapa_acum_trecho ORDER BY gid_tr, car