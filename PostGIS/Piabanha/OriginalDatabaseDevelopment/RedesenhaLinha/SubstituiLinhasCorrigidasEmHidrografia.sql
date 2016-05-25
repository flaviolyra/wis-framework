UPDATE hidrografia SET geomproj_uni = n.geomproj
FROM novo_desenho_trecho AS n
WHERE hidrografia.gid = n.gid
