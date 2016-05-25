UPDATE hidrografia SET geomproj_uni = el.geom_estendida
FROM estende_linhas AS el
WHERE hidrografia.gid = el.gid;