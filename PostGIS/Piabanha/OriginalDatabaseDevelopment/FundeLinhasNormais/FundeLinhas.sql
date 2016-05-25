UPDATE hidrografia SET geomproj_uni = lf.geom_fusao
FROM linhas_a_fundir AS lf
WHERE hidrografia.gid = lf.id_outra;