INSERT INTO setores_censitarios_piabanha
SELECT * FROM setores_censitarios
WHERE cd_geocodm IN (SELECT DISTINCT s.cd_geocodm FROM
set_cens_area_contrib AS sa INNER JOIN setores_censitarios AS s ON sa.gid_set_agr = s.gid)