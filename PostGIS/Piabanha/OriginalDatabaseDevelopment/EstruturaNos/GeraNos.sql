INSERT INTO nos (geomproj)
SELECT DISTINCT ST_StartPoint(geomproj_uni) FROM hidrografia
UNION
SELECT DISTINCT ST_EndPoint(geomproj_uni) FROM hidrografia;