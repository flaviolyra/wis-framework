UPDATE hidrografia SET geomproj_uni = nh.geomproj
FROM
(SELECT h.gid, ST_SetPoint(h.geomproj_uni,ST_NumPoints(geomproj_uni)-1,n.geomproj) AS geomproj
FROM hidrografia AS h
INNER JOIN nos AS n
ON h.no_para = n.id) AS nh
WHERE hidrografia.gid = nh.gid;