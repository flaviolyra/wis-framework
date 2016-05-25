UPDATE hidrografia SET geomproj_uni = ltp.nova_geom_linha2
FROM linhas_terminais_proximos AS ltp
WHERE hidrografia.gid = ltp.id_linha2