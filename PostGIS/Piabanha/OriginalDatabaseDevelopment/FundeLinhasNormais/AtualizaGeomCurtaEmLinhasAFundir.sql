UPDATE linhas_a_fundir SET geom_curta = hidrografia.geomproj_uni
FROM hidrografia
WHERE linhas_a_fundir.id_curta = hidrografia.gid;