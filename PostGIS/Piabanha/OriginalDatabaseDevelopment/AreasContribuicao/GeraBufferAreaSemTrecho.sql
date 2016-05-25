CREATE TABLE buffer_area_sem_trecho AS
SELECT gid, ST_Buffer(geomproj, 50.) AS geomproj FROM area_sem_trecho