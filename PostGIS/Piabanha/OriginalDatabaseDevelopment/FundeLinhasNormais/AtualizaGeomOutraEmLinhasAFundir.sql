UPDATE linhas_a_fundir SET geom_outra = hidrografia.geomproj_uni
FROM hidrografia
WHERE linhas_a_fundir.id_outra = hidrografia.gid;