CREATE TABLE parte_setor_piabanha AS
SELECT gid_set_agr, sum(parte)AS parte FROM set_cens_area_contrib GROUP BY gid_set_agr