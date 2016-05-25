SELECT * FROM
(SELECT id_no, nm_afl, id_tr, area_mont_tr, id_tr_afl, area_mont_tr_afl FROM rio_principal('7534', 10452202, TRUE, NULL, FALSE) AS r
ORDER BY area_mont_tr_afl DESC LIMIT 4) AS bp
ORDER BY area_mont_tr DESC
