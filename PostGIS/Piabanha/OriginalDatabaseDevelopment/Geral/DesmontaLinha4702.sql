SELECT ordem,
ST_AsBinary(geom_pt)
FROM
desfaz_linha (
(SELECT geomproj_uni FROM hidrografia WHERE gid = 4702),
0, FALSE)