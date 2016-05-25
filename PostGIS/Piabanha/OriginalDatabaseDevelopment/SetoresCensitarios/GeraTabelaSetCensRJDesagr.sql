INSERT INTO set_cens_rj_desagr (gid_agr, cd_geocodi, geom_uni)
SELECT gid, cd_geocodi, ST_Transform(ST_Force_2d((ST_Dump(geom)).geom), 4326) FROM setores_censitarios