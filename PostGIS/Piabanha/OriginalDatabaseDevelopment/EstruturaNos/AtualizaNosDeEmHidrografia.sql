UPDATE hidrografia SET no_de = n.id
FROM nos AS n
WHERE ST_StartPoint(hidrografia.geomproj_uni) = n.geomproj;