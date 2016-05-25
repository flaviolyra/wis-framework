UPDATE linhas_proximas_terminais SET geom_nlo1 = NULL
WHERE ST_NumPoints(geom_nlo1) < 2;
UPDATE linhas_proximas_terminais SET geom_nlo2 = NULL
WHERE ST_NumPoints(geom_nlo2) < 2;
