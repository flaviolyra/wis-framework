SELECT * FROM
(SELECT id_no, nm_afl, id_tr, area_mont_tr, id_tr_afl, area_mont_tr_afl FROM rio_principal('736975', 8782857, FALSE, 250094899, TRUE) AS r
WHERE id_tr_afl NOT IN (SELECT 933020111) ORDER BY area_mont_tr_afl DESC LIMIT 4) AS bp
ORDER BY area_mont_tr DESC
