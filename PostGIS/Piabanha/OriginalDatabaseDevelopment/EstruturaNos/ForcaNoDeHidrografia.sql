UPDATE hidrografia SET geomproj_uni = nh.geomproj
FROM
(SELECT h.gid, ST_SetPoint(h.geomproj_uni,0,n.geomproj) AS geomproj
FROM hidrografia AS h
INNER JOIN nos AS n
ON h.no_de = n.id) AS nh
WHERE hidrografia.gid = nh.gid;