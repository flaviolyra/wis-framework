SELECT h.gid, h.no_de, ST_Distance(ST_StartPoint(h.geomproj_uni), n.geomproj) AS dist_de
FROM hidrografia AS h
INNER JOIN nos AS n
ON h.no_de = n.id
ORDER BY dist_de DESC;