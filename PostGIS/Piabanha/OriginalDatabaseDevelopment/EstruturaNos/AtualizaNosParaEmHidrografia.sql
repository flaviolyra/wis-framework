UPDATE hidrografia SET no_para = n.id
FROM nos AS n
WHERE ST_EndPoint(hidrografia.geomproj_uni) = n.geomproj;