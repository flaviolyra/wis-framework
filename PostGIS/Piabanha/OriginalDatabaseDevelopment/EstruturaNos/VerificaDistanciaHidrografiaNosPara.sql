SELECT h.gid, h.no_para, ST_Distance(ST_EndPoint(h.geomproj_uni), n.geomproj) AS dist_para
FROM hidrografia AS h
INNER JOIN nos AS n
ON h.no_para = n.id
ORDER BY dist_para DESC;